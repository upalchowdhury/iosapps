//
//  OnboardingContainerView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPage = 0
    @EnvironmentObject var userSettings: UserSettings
    
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Page indicator
                HStack {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index <= currentPage ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Content
                TabView(selection: $currentPage) {
                    WelcomeView(onNext: nextPage)
                        .tag(0)
                    
                    HabitSelectionView(onNext: nextPage)
                        .tag(1)
                    
                    NotificationPermissionView(onNext: nextPage)
                        .tag(2)
                    
                    PaywallView(onComplete: completeOnboarding, onSkip: completeOnboarding)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
            }
        }
    }
    
    private func nextPage() {
        withAnimation {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        }
    }
    
    private func completeOnboarding() {
        userSettings.hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(UserSettings.shared)
}
