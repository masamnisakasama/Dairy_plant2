
import SwiftUI

struct HomeView: View {
    
    @State var selectedTab: Tab = Tab.today
    
    var body: some View {
        
        TabView (selection: $selectedTab) {
            
            
            TodayView(selectedTab: $selectedTab)
                .tabItem {
                    Text("Today")
                    Image(systemName: "calendar")
                }
                .tag(Tab.today)
            
            ThingsView()
                .tabItem {
                    Text("Things")
                    Image(systemName: "heart")
                }
                .tag(Tab.things)
            
            RemindersView()
                .tabItem {
                    Text("Reminders")
                    Image(systemName: "bell")
                }
                .tag(Tab.reminders)
            
            
            PlantListView()  // ← 図鑑タブ
                       .tabItem {
                           Text("album")
                           Image(systemName: "leaf.fill")
                       }
                       .tag(Tab.plants)
            
            SettingsView()
                .tabItem {
                    Text("stats")
                    Image(systemName: "gear")
                }
                .tag(Tab.settings)
        }
        
    }
}

enum Tab: Int {
    case today = 0
    case things = 1
    case reminders = 2
    case settings = 3
    case plants = 4
}

#Preview {
    HomeView()
}
