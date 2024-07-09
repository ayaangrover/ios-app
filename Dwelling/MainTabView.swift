import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NYTView()
                .tabItem {
                    Label("NYT", systemImage: "newspaper")
                }
            
            GuardianNewsView()
                .tabItem {
                    Label("Guardian", systemImage: "newspaper.fill")
                }
            
            SportsNewsView()
                .tabItem {
                    Label("Sports", systemImage: "sportscourt")
                }

            WebPageView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
