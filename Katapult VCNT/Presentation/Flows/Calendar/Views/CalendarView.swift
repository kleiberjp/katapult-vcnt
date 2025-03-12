import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            PropertyNavigationBar()
            
            WeekNavigationView(
                currentWeek: viewModel.currentWeek,
                onPrevious: viewModel.moveToPreviousWeek,
                onNext: viewModel.moveToNextWeek
            )
            
            CalendarGridView(
                viewModel: viewModel,
                daysToShow: 7
            )
        }
    }
} 