#if canImport(WidgetKit)
import WidgetKit
import SwiftUI

struct TrainWidgetBundle: WidgetBundle {
    var body: some Widget {
#if canImport(ActivityKit)
        TrainLiveActivityWidget()
#endif
    }
}
#endif
