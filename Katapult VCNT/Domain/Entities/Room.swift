import Foundation

struct Room: Identifiable, Equatable {
    let id: String
    let name: String
    let type: String
    let rate: Decimal
} 