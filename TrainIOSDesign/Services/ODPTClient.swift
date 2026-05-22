import Foundation

enum ODPTClientError: Error {
    case invalidURL
    case badResponse
}

actor ODPTClient {
    private let baseURL = URL(string: "https://api.odpt.org/api/v4")!
    private let maxPollingBackoffSeconds: TimeInterval = 180
    private let urlSession: URLSession
    private let apiKey: String
    private var pollingTask: Task<Void, Never>?

    init(apiKey: String, urlSession: URLSession = .shared) {
        self.apiKey = apiKey
        self.urlSession = urlSession
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func startPollingTrainInformation(
        railway: String?,
        interval: TimeInterval = 30,
        onUpdate: @escaping @MainActor ([ODPTTrainInformation]) -> Void
    ) {
        stopPolling()
        pollingTask = Task {
            var backoff: TimeInterval = interval
            while !Task.isCancelled {
                do {
                    let info = try await fetchTrainInformation(railway: railway)
                    await onUpdate(info)
                    backoff = interval
                } catch {
                    backoff = min(backoff * 2, maxPollingBackoffSeconds)
                }
                let nanos = UInt64(backoff * 1_000_000_000)
                try? await Task.sleep(nanoseconds: nanos)
            }
        }
    }

    func fetchTrainInformation(railway: String?) async throws -> [ODPTTrainInformation] {
        var components = URLComponents(url: baseURL.appendingPathComponent("odpt:TrainInformation"), resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem(name: "acl:consumerKey", value: apiKey)]
        if let railway, !railway.isEmpty {
            queryItems.append(URLQueryItem(name: "odpt:railway", value: railway))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw ODPTClientError.invalidURL
        }

        let (data, response) = try await urlSession.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw ODPTClientError.badResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([ODPTTrainInformation].self, from: data)
    }
}
