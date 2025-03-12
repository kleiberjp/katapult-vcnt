import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    private let tabIconSize: CGFloat = 14
    private let activeColor = Color.green.opacity(0.2)
    private let inactiveColor = Color.gray.opacity(0.2)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label {
                        Text("Today")
                    } icon: {
                        Image(systemName: "calendar.day.timeline.left")
                            .resizable()
                            .frame(width: tabIconSize, height: tabIconSize)
                    }
                }
                .tag(0)
            
            CalendarContainerView()
                .tabItem {
                    Label {
                        Text("Calendar")
                    } icon: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: tabIconSize, height: tabIconSize)
                    }
                }
                .tag(1)
            
            RoomsView()
                .tabItem {
                    Label {
                        Text("Rooms")
                    } icon: {
                        Image(systemName: "bed.double")
                            .resizable()
                            .frame(width: tabIconSize, height: tabIconSize)
                    }
                }
                .tag(2)
            
            ReportsView()
                .tabItem {
                    Label {
                        Text("Reports")
                    } icon: {
                        Image(systemName: "chart.bar")
                            .resizable()
                            .frame(width: tabIconSize, height: tabIconSize)
                    }
                }
                .tag(3)
        }
        .accentColor(activeColor)
        .tint(inactiveColor)
    }
}

// Placeholder views for other tabs
struct TodayView: View {
    var body: some View {
        Text("Today View")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RoomsView: View {
    var body: some View {
        Text("Rooms View")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ReportsView: View {
    var body: some View {
        Text("Reports View")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 
