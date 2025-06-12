internal import Combine
import Foundation
import Network

class NetworkStatusMonitor: ObservableObject {
    enum Status: String {
        case offline = "Offline"
        case wifi = "Wi-Fi"
        case cellular = "Mobile"
        case unknown = "Unknown"
    }

    @Published var status: Status = .unknown
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkStatusMonitor")

    init() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self?.status = .wifi
                    } else if path.usesInterfaceType(.cellular) {
                        self?.status = .cellular
                    } else {
                        self?.status = .unknown
                    }
                } else {
                    self?.status = .offline
                }
            }
        }
        monitor?.start(queue: queue)
    }

    deinit {
        monitor?.cancel()
    }
}
