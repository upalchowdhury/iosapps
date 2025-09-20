//
//  NotificationPermissionView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    let onNext: () -> Void
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack(spacing: 30) {
            // Icon
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            // Title and Description
            VStack(spacing: 16) {
                Text("Stay on Track")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Get gentle reminders and motivational messages to help you succeed")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Benefits
            VStack(alignment: .leading, spacing: 12) {
                BenefitRow(icon: "sun.max.fill", text: "Morning motivation")
                BenefitRow(icon: "clock.fill", text: "Midday check-ins")
                BenefitRow(icon: "moon.stars.fill", text: "Evening reflections")
                BenefitRow(icon: "trophy.fill", text: "Milestone celebrations")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: requestNotificationPermission) {
                    Text("Enable Notifications")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                Button(action: onNext) {
                    Text("Maybe Later")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                userSettings.notificationsEnabled = granted
                if granted {
                    scheduleDefaultNotifications()
                }
                onNext()
            }
        }
    }
    
    private func scheduleDefaultNotifications() {
        // Basic notification scheduling - can be enhanced later
        print("Notifications enabled - scheduling reminders")
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

#Preview {
    NotificationPermissionView(onNext: {})
        .environmentObject(UserSettings.shared)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
