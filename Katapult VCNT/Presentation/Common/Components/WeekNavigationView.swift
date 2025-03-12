import SwiftUI

struct WeekNavigationView: View {
    let currentWeek: Date
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d"
        return formatter
    }()
    
    private let rangeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    private var todayString: String {
        if currentWeek.isToday {
            return "Today"
        } else if currentWeek.isTomorrow {
            return "Tomorrow"
        } else {
            return DateFormatter.dayAndDate.string(from: currentWeek)
        }
    }
    
    private var weekRangeString: String {
        let calendar = Calendar.current
        let weekDates = calendar.daysInWeek(for: currentWeek)
        
        guard let firstDay = weekDates.first, let lastDay = weekDates.last else {
            return ""
        }
        
        return "\(DateFormatter.monthAndDay.string(from: firstDay)) - \(DateFormatter.monthAndDay.string(from: lastDay))"
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Current date (Today, Tomorrow, or day format)
            Text(todayString)
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            // Week range
            Text(weekRangeString)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 8) {
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: onNext) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
} 