import Foundation
import Combine
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var calendarData: WeeklyCalendarData?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentWeek: Date = Date()
    @Published var dayMetrics: [Date: DayMetrics] = [:]
    @Published var roomGroupMetrics: [String: RoomGroupMetrics] = [:]
    
    private let getWeeklyCalendarUseCase: GetWeeklyCalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getWeeklyCalendarUseCase: GetWeeklyCalendarUseCase) {
        self.getWeeklyCalendarUseCase = getWeeklyCalendarUseCase
        loadCurrentWeek()
    }
    
    func loadCurrentWeek() {
        isLoading = true
        
        getWeeklyCalendarUseCase.execute(week: currentWeek, propertyId: "1")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] data in
                    self?.calendarData = data
                    self?.calculateMetrics(for: data)
                }
            )
            .store(in: &cancellables)
    }
    
    private func calculateMetrics(for data: WeeklyCalendarData) {
        // Calculate day metrics
        data.weekDates.forEach { date in
            dayMetrics[date] = calculateDayMetrics(date: date, data: data)
        }
        
        // Calculate room group metrics
        let groups = groupRooms(data.rooms)
        groups.forEach { group in
            roomGroupMetrics[group.id] = calculateRoomGroupMetrics(group: group, data: data)
        }
    }
    
    private func calculateDayMetrics(date: Date, data: WeeklyCalendarData) -> DayMetrics {
        let totalRooms = data.rooms.count
        if totalRooms == 0 { return DayMetrics(date: date, occupancyPercentage: 0, occupiedRoomsCount: 0) }
        
        let dateReservations = data.reservations.filter { reservation in
            date >= reservation.checkIn && date <= reservation.checkOut
        }
        
        let occupiedRoomIds = Set(dateReservations.map { $0.roomId })
        let occupiedCount = occupiedRoomIds.count
        let percentage = (Double(occupiedCount) / Double(totalRooms)) * 100.0
        
        return DayMetrics(
            date: date,
            occupancyPercentage: percentage,
            occupiedRoomsCount: occupiedCount
        )
    }
    
    private func calculateRoomGroupMetrics(group: RoomGroup, data: WeeklyCalendarData) -> RoomGroupMetrics {
        let groupRoomIds = Set(group.rooms.map { $0.id })
        var dailyRevenue: [Date: Decimal] = [:]
        
        data.weekDates.forEach { date in
            let dateReservations = data.reservations.filter { reservation in
                let isWithinRange = date >= reservation.checkIn && date <= reservation.checkOut
                let isInGroup = groupRoomIds.contains(reservation.roomId)
                return isWithinRange && isInGroup
            }
            
            let revenue = dateReservations.reduce(Decimal(0)) { total, reservation in
                if let room = data.rooms.first(where: { $0.id == reservation.roomId }) {
                    return total + room.rate
                }
                return total
            }
            
            dailyRevenue[date] = revenue
        }
        
        return RoomGroupMetrics(roomGroup: group, dailyRevenue: dailyRevenue)
    }
    
    private func groupRooms(_ rooms: [Room]) -> [RoomGroup] {
        let groupedRooms = Dictionary(grouping: rooms) { $0.name }
        
        return groupedRooms.map { name, rooms in
            RoomGroup(
                id: name,
                name: name,
                type: rooms.first?.type ?? "",
                rooms: rooms
            )
        }.sorted { $0.name < $1.name }
    }
    
    func moveToNextWeek() {
        currentWeek = Calendar.current.date(
            byAdding: .weekOfYear,
            value: 1,
            to: currentWeek
        ) ?? currentWeek
        loadCurrentWeek()
    }
    
    func moveToPreviousWeek() {
        currentWeek = Calendar.current.date(
            byAdding: .weekOfYear,
            value: -1,
            to: currentWeek
        ) ?? currentWeek
        loadCurrentWeek()
    }
} 
