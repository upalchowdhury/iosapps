//
//  ContentView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Group {
            if userSettings.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingContainerView()
            }
        }
        .animation(.easeInOut, value: userSettings.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings.shared)
}
