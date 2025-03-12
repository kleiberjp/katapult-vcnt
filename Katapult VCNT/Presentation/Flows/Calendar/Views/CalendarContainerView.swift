import SwiftUI

struct CalendarContainerView: View {
    @StateObject private var viewModel: CalendarViewModel
    
    init() {
        // Create mock repository for demo purposes
        let repository = MockReservationRepository()
        
        // Create use case
        let useCase = GetWeeklyCalendarUseCaseImpl(repository: repository)
        
        // Create view model
        let viewModel = CalendarViewModel(getWeeklyCalendarUseCase: useCase)
        
        // Initialize StateObject
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        CalendarView(viewModel: viewModel)
    }
} 