import Foundation

struct Reservation: Identifiable, Equatable {
    let id: String
    let roomId: String
    let guestName: String
    let checkIn: Date
    let checkOut: Date
    let status: ReservationStatus
}

enum ReservationStatus {
    case confirmed
    case pending
    case cancelled
} 