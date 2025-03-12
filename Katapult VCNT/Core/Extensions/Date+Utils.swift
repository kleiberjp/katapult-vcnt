import Foundation

extension Date {
    var isInPast: Bool {
        self < Calendar.current.startOfDay(for: Date())
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
} 