import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            PropertyNavigationBar()
            
            WeekNavigationView(
                currentWeek: viewModel.currentWeek,
                onPrevious: viewModel.moveToPreviousWeek,
                onNext: viewModel.moveToNextWeek
            )
            
            if let calendarData = viewModel.calendarData {
                CalendarGridView(
                    data: calendarData,
                    daysToShow: sizeClass == .compact ? 4 : 7
                )
            }
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        )
    }
} 