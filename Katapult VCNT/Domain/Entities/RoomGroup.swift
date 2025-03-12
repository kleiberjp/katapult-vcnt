import Foundation

struct RoomGroup: Identifiable {
    let id: String
    let name: String
    let type: String
    let rooms: [Room]
} 