import SwiftUI

struct WeekNavigationView: View {
    let currentWeek: Date
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            
            Text(dateFormatter.string(from: currentWeek))
                .font(.headline)
            
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
} 