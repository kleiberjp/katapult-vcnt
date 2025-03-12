import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let daysToShow: Int
    
    @State private var expandedRoomGroups: Set<String> = []
    @State private var scrollOffset: CGFloat = 0
    
    private let roomColumnWidth: CGFloat = 140
    private let horizontalPadding: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            // Days row with occupancy
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        // Room header cell
                        Text("Rooms")
                            .font(.subheadline)
                            .frame(width: roomColumnWidth, height: 44)
                            .background(Color.white)
                            .border(Color.gray.opacity(0.2))
                        
                        if let data = viewModel.calendarData {
                            ForEach(data.weekDates.prefix(daysToShow), id: \.self) { date in
                                dateHeaderCell(date)
                            }
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            scrollOffset = value.translation.width
                            NotificationCenter.default.post(
                                name: .calendarScrollDidChange,
                                object: nil,
                                userInfo: ["offset": scrollOffset]
                            )
                        }
                )
            }
            
            // Room groups and reservations
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.roomGroupMetrics.values), id: \.roomGroup.id) { groupMetric in
                        roomGroupSection(groupMetric)
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
    }
    
    private func dateHeaderCell(_ date: Date) -> some View {
        let metrics = viewModel.dayMetrics[date]
        
        return VStack(spacing: 4) {
            Text(DateFormatter.dayAndDate.string(from: date))
                .font(.subheadline)
            
            if let occupancy = metrics?.occupancyPercentage {
                Text("\(Int(occupancy))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: 44)
        .background(Color.white)
        .border(Color.gray.opacity(0.2))
    }
    
    private func roomGroupSection(_ groupMetric: RoomGroupMetrics) -> some View {
        VStack(spacing: 0) {
            roomGroupHeader(groupMetric.roomGroup)
            
            if isExpanded(groupMetric.roomGroup.id) {
                roomsList(groupMetric.roomGroup)
            }
        }
        .border(Color.gray.opacity(0.2))
    }
    
    private func roomGroupHeader(_ group: RoomGroup) -> some View {
        Button(action: { toggleRoomGroup(group.id) }) {
            HStack {
                // Room info section
                roomGroupInfo(group)
                
                // Revenue section
                revenueSection(group)
            }
            .frame(height: 50)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func roomGroupInfo(_ group: RoomGroup) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(group.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(group.type)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: roomColumnWidth - (horizontalPadding * 2) - 20, alignment: .leading)
            
            Image(systemName: isExpanded(group.id) ? "chevron.down" : "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.horizontal, horizontalPadding)
        .frame(width: roomColumnWidth)
    }
    
    private func revenueSection(_ group: RoomGroup) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    if let metrics = viewModel.roomGroupMetrics[group.id] {
                        ForEach(viewModel.calendarData?.weekDates.prefix(daysToShow) ?? [], id: \.self) { date in
                            revenueCellFor(date: date, metrics: metrics)
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .calendarScrollDidChange)) { notification in
                if let offset = notification.userInfo?["offset"] as? CGFloat {
                    proxy.scrollTo(offset, anchor: .leading)
                }
            }
        }
    }
    
    private func revenueCellFor(date: Date, metrics: RoomGroupMetrics) -> some View {
        let revenue = metrics.dailyRevenue[date] ?? 0
        let formattedRevenue = NumberFormatter.currency.string(from: NSDecimalNumber(decimal: revenue)) ?? "$0.00"
        
        return Text(formattedRevenue)
            .font(.caption)
            .foregroundColor(.gray)
            .frame(width: 80)
            .background(Color.white)
            .border(Color.gray.opacity(0.2))
    }
    
    private func roomsList(_ group: RoomGroup) -> some View {
        ForEach(group.rooms) { room in
            roomRow(room)
        }
    }
    
    private func roomRow(_ room: Room) -> some View {
        HStack(spacing: 0) {
            // Room ID section
            HStack {
                Text("+ \(room.id)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: roomColumnWidth - (horizontalPadding * 2), alignment: .leading)
            .padding(.horizontal, horizontalPadding)
            .background(Color.white)
            
            // Reservations section with synchronized scrolling
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.calendarData?.weekDates.prefix(daysToShow) ?? [], id: \.self) { date in
                            reservationCell(for: room, on: date)
                                .frame(width: 80)
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .calendarScrollDidChange)) { notification in
                    if let offset = notification.userInfo?["offset"] as? CGFloat {
                        proxy.scrollTo(offset, anchor: .leading)
                    }
                }
            }
        }
        .frame(height: 44)
        .background(Color.white)
        .border(Color.gray.opacity(0.2))
    }
    
    private func reservationCell(for room: Room, on date: Date) -> some View {
        let reservation = findReservation(for: room.id, on: date)
        
        return Group {
            if let reservation = reservation {
                ReservationView(reservation: reservation, date: date)
            } else {
                EmptyCell()
            }
        }
        .background(Color.white)
        .border(Color.gray.opacity(0.2))
    }
    
    private func findReservation(for roomId: String, on date: Date) -> Reservation? {
        viewModel.calendarData?.reservations.first { reservation in
            reservation.roomId == roomId &&
            date >= reservation.checkIn &&
            date <= reservation.checkOut
        }
    }
    
    private func isExpanded(_ groupId: String) -> Bool {
        expandedRoomGroups.contains(groupId)
    }
    
    private func toggleRoomGroup(_ groupId: String) {
        if isExpanded(groupId) {
            expandedRoomGroups.remove(groupId)
        } else {
            expandedRoomGroups.insert(groupId)
        }
    }
}

private struct ReservationView: View {
    let reservation: Reservation
    let date: Date
    
    private var reservationColor: Color {
        let today = Date()
        if date < Calendar.current.startOfDay(for: today) {
            return Color.gray.opacity(0.2) // Past reservations
        } else if date > Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today {
            return Color.blue.opacity(0.2) // Future reservations
        } else {
            return Color.green.opacity(0.2) // Current/In progress reservations
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(reservation.guestName)
                .font(.caption)
                .foregroundColor(date < Date() ? .gray : .primary)
                .lineLimit(1)
            
            if reservation.status == .pending {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(reservationColor)
        )
        .padding(2)
    }
}

private struct EmptyCell: View {
    var body: some View {
        Color.white
    }
}

// Add Notification name extension
extension Notification.Name {
    static let calendarScrollDidChange = Notification.Name("calendarScrollDidChange")
} 
