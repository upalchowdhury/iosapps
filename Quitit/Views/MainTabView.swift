//
//  MainTabView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import CoreData

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            DashboardView(viewContext: viewContext)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Dashboard")
            }
            
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
            
            InsightsView(viewContext: viewContext)
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Insights")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
