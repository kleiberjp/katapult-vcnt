import Foundation
import Combine

protocol ReservationRepository {
    func getReservations(
        forWeek startDate: Date,
        propertyId: String
    ) -> AnyPublisher<[Reservation], Error>
    
    func getRooms(
        propertyId: String
    ) -> AnyPublisher<[Room], Error>
} 