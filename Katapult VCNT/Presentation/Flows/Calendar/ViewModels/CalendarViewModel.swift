import Foundation
import Combine
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var calendarData: WeeklyCalendarData?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentWeek: Date = Date()
    
    private let getWeeklyCalendarUseCase: GetWeeklyCalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getWeeklyCalendarUseCase: GetWeeklyCalendarUseCase) {
        self.getWeeklyCalendarUseCase = getWeeklyCalendarUseCase
        loadCurrentWeek()
    }
    
    func loadCurrentWeek() {
        isLoading = true
        
        getWeeklyCalendarUseCase.execute(
            week: currentWeek,
            propertyId: "current_property_id" // This should come from UserDefaults or similar
        )
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
            }
        )
        .store(in: &cancellables)
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