import Foundation
import Combine

protocol GetWeeklyCalendarUseCase {
    func execute(
        week: Date,
        propertyId: String
    ) -> AnyPublisher<WeeklyCalendarData, Error>
}

struct WeeklyCalendarData {
    let rooms: [Room]
    let reservations: [Reservation]
    let weekDates: [Date]
}

class GetWeeklyCalendarUseCaseImpl: GetWeeklyCalendarUseCase {
    private let repository: ReservationRepository
    
    init(repository: ReservationRepository) {
        self.repository = repository
    }
    
    func execute(
        week: Date,
        propertyId: String
    ) -> AnyPublisher<WeeklyCalendarData, Error> {
        Publishers.CombineLatest(
            repository.getRooms(propertyId: propertyId),
            repository.getReservations(forWeek: week, propertyId: propertyId)
        )
        .map { rooms, reservations in
            WeeklyCalendarData(
                rooms: rooms,
                reservations: reservations,
                weekDates: Calendar.current.daysInWeek(for: week)
            )
        }
        .eraseToAnyPublisher()
    }
} 