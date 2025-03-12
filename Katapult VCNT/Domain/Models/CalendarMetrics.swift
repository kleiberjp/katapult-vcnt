import Foundation

struct DayMetrics {
    let date: Date
    let occupancyPercentage: Double
    let occupiedRoomsCount: Int
}

struct RoomGroupMetrics {
    let roomGroup: RoomGroup
    let dailyRevenue: [Date: Decimal]
} 