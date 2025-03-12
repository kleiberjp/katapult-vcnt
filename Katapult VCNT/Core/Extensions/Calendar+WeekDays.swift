import Foundation

extension Calendar {
    func daysInWeek(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        
        // Find the start of the week
        let weekday = calendar.component(.weekday, from: today)
        let weekStart = calendar.date(byAdding: .day, value: 1 - weekday, to: today)!
        
        // Generate array of dates for the week
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekStart)
        }
    }
} 