import Foundation
import Combine

enum WebSocketEvent {
    case rideUpdate(RideResponse)
    case chatMessage(ChatMessage)
    case driverStatusUpdate(DriverStatus)
    case error(Error)
}

class WebSocketService {
    static let shared = WebSocketService()
    private var webSocket: URLSessionWebSocketTask?
    private let eventsSubject = PassthroughSubject<WebSocketEvent, Never>()
    
    var events: AnyPublisher<WebSocketEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }
    
    func connect() {
        guard let url = URL(string: "ws://localhost:8000/ws") else { return }
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    self?.handleData(data)
                @unknown default:
                    break
                }
                self?.receiveMessage()
            case .failure(let error):
                self?.eventsSubject.send(.error(error))
            }
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        handleData(data)
    }
    
    private func handleData(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let event = try decoder.decode(WebSocketEventWrapper.self, from: data)
            
            switch event.type {
            case "ride_update":
                if let ride = try? decoder.decode(RideResponse.self, from: event.data) {
                    eventsSubject.send(.rideUpdate(ride))
                }
            case "chat_message":
                if let message = try? decoder.decode(ChatMessage.self, from: event.data) {
                    eventsSubject.send(.chatMessage(message))
                }
            case "driver_status":
                if let status = try? decoder.decode(DriverStatus.self, from: event.data) {
                    eventsSubject.send(.driverStatusUpdate(status))
                }
            default:
                break
            }
        } catch {
            eventsSubject.send(.error(error))
        }
    }
    
    func send(_ event: WebSocketEvent) {
        // Implement sending events to the server
    }
}

struct WebSocketEventWrapper: Codable {
    let type: String
    let data: Data
} 