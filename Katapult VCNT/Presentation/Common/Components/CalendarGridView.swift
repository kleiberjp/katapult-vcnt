import SwiftUI

struct CalendarGridView: View {
    let data: WeeklyCalendarData
    let daysToShow: Int
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE\nMMM d"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with dates
                HStack(spacing: 0) {
                    roomHeaderCell
                    
                    ForEach(data.weekDates.prefix(daysToShow), id: \.self) { date in
                        dateHeaderCell(date)
                    }
                }
                
                // Room rows with reservations
                ForEach(data.rooms) { room in
                    roomRow(room)
                }
            }
        }
    }
    
    private var roomHeaderCell: some View {
        Text("Rooms")
            .font(.headline)
            .frame(width: 120, height: 60)
            .background(Color(.systemBackground))
            .border(Color(.systemGray5))
    }
    
    private func dateHeaderCell(_ date: Date) -> some View {
        Text(dateFormatter.string(from: date))
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .frame(minWidth: 80, maxWidth: .infinity, height: 60)
            .background(Color(.systemBackground))
            .border(Color(.systemGray5))
    }
    
    private func roomRow(_ room: Room) -> some View {
        HStack(spacing: 0) {
            // Room info cell
            VStack(alignment: .leading) {
                Text(room.name)
                    .font(.subheadline)
                Text(room.type)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 80)
            .padding(.horizontal, 8)
            .background(Color(.systemBackground))
            .border(Color(.systemGray5))
            
            // Reservation cells for each day
            ForEach(data.weekDates.prefix(daysToShow), id: \.self) { date in
                reservationCell(for: room, on: date)
            }
        }
    }
    
    private func reservationCell(for room: Room, on date: Date) -> some View {
        let reservation = findReservation(for: room.id, on: date)
        
        return Group {
            if let reservation = reservation {
                ReservationView(reservation: reservation)
            } else {
                EmptyCell()
            }
        }
        .frame(minWidth: 80, maxWidth: .infinity, height: 80)
        .border(Color(.systemGray5))
    }
    
    private func findReservation(for roomId: String, on date: Date) -> Reservation? {
        data.reservations.first { reservation in
            reservation.roomId == roomId &&
            date >= reservation.checkIn &&
            date <= reservation.checkOut
        }
    }
}

private struct ReservationView: View {
    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(reservation.guestName)
                .font(.caption)
                .lineLimit(1)
            
            Text(reservation.status.rawValue)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .cornerRadius(4)
        }
        .padding(6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(statusColor.opacity(0.1))
    }
    
    private var statusColor: Color {
        switch reservation.status {
        case .confirmed:
            return .green
        case .pending:
            return .orange
        case .cancelled:
            return .red
        }
    }
}

private struct EmptyCell: View {
    var body: some View {
        Color(.systemBackground)
    }
} 