import Foundation
import CoreLocation
import UserNotifications
import Combine
import OSLog

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var isApproachingDestination = false

    private let locationManager = CLLocationManager()
    private let logger = Logger(subsystem: "com.trainiosdesign.app", category: "LocationManager")
    private var trackedRegionIdentifier: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        // Info.plist の background mode(location) とセットで有効化し、バッテリー影響を許容して降車通知精度を優先する。
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func requestPermissions() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    func startLocationTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }

    func startGeofence(
        center: CLLocationCoordinate2D,
        radius: CLLocationDistance = 500,
        identifier: String
    ) {
        stopGeofence()
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        trackedRegionIdentifier = identifier
        locationManager.startMonitoring(for: region)
    }

    func stopGeofence() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        trackedRegionIdentifier = nil
        isApproachingDestination = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region.identifier == trackedRegionIdentifier else { return }
        isApproachingDestination = true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Location error: \(error.localizedDescription, privacy: .public)")
    }

    static func isWithinGeofence(
        current: CLLocationCoordinate2D,
        destination: CLLocationCoordinate2D,
        radiusMeters: CLLocationDistance
    ) -> Bool {
        let from = CLLocation(latitude: current.latitude, longitude: current.longitude)
        let to = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return from.distance(from: to) <= radiusMeters
    }
}
