import Foundation
import Combine

class MockReservationRepository: ReservationRepository {
    func getReservations(forWeek startDate: Date, propertyId: String) -> AnyPublisher<[Reservation], Error> {
        // Create some mock reservations
        let calendar = Calendar.current
        let weekDates = calendar.daysInWeek(for: startDate)
        
        let reservations = [
            Reservation(
                id: "1",
                roomId: "room1",
                guestName: "Robert Fox",
                checkIn: weekDates[0],
                checkOut: weekDates[2],
                status: .confirmed
            ),
            Reservation(
                id: "2",
                roomId: "room1",
                guestName: "Bessie Cooper",
                checkIn: weekDates[3],
                checkOut: weekDates[5],
                status: .confirmed
            ),
            Reservation(
                id: "3",
                roomId: "room2",
                guestName: "Cameron Williamson",
                checkIn: weekDates[1],
                checkOut: weekDates[3],
                status: .confirmed
            ),
            Reservation(
                id: "4",
                roomId: "room3",
                guestName: "Albert Flores",
                checkIn: weekDates[2],
                checkOut: weekDates[4],
                status: .pending
            ),
            Reservation(
                id: "5",
                roomId: "room4",
                guestName: "Marvin McKinney",
                checkIn: weekDates[0],
                checkOut: weekDates[6],
                status: .confirmed
            )
        ]
        
        return Just(reservations)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    func getRooms(propertyId: String) -> AnyPublisher<[Room], Error> {
        // Create some mock rooms
        let rooms = [
            Room(id: "room1", name: "Superior Room", type: "with King Bed, Ocean View", rate: 406.27),
            Room(id: "room2", name: "Standard Room", type: "with Queen Bed", rate: 406.27),
            Room(id: "room3", name: "Deluxe Suite", type: "with King Bed", rate: 406.27),
            Room(id: "room4", name: "Family Room", type: "with 2 Queen Beds", rate: 406.27)
        ]
        
        return Just(rooms)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
} 