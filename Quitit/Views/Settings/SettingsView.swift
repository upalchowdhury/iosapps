//
//  SettingsView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            List {
                // Premium Status Section
                Section {
                    PremiumStatusRow()
                }
                
                // Notifications Section
                Section("Notifications") {
                    NavigationLink("Notification Settings") {
                        NotificationSettingsView()
                    }
                }
                
                // Habit Management Section
                Section("Habit Management") {
                    NavigationLink("Habit Settings") {
                        HabitSettingsView()
                    }
                }
                
                // Data & Privacy Section
                Section("Data & Privacy") {
                    Button("Export Data") {
                        // TODO: Implement data export
                    }
                    
                    Button("Reset All Data") {
                        // TODO: Implement data reset with confirmation
                    }
                    .foregroundColor(.red)
                }
                
                // Help & Support Section
                Section("Help & Support") {
                    Link("Contact Support", destination: URL(string: "mailto:support@quitit.app")!)
                    Link("Privacy Policy", destination: URL(string: "https://quitit.app/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://quitit.app/terms")!)
                }
                
                // About Section
                Section("About") {
                    NavigationLink("About QuitIt") {
                        AboutView()
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct PremiumStatusRow: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if userSettings.isPremiumUser {
                    Text("QuitIt Premium")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Active subscription")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Unlock all features")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if userSettings.isPremiumUser {
                Image(systemName: "crown.fill")
                    .foregroundColor(.orange)
            } else {
                Button("Upgrade") {
                    // TODO: Show paywall
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .cornerRadius(6)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NotificationSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        List {
            Section("General") {
                Toggle("Enable Notifications", isOn: $userSettings.notificationsEnabled)
            }
            
            if userSettings.notificationsEnabled {
                Section("Reminder Times") {
                    DatePicker("Morning Reminder", selection: $userSettings.morningReminderTime, displayedComponents: .hourAndMinute)
                    
                    DatePicker("Midday Check", selection: $userSettings.middayReminderTime, displayedComponents: .hourAndMinute)
                    
                    DatePicker("Evening Reflection", selection: $userSettings.eveningReminderTime, displayedComponents: .hourAndMinute)
                }
                
                Section("Smart Alerts") {
                    Toggle("High-risk Time Warnings", isOn: .constant(true))
                        .disabled(!userSettings.isPremiumUser)
                    
                    Toggle("Streak Milestone Alerts", isOn: .constant(true))
                    
                    Toggle("Weekly Summary", isOn: .constant(true))
                        .disabled(!userSettings.isPremiumUser)
                }
                
                if !userSettings.isPremiumUser {
                    Section {
                        Text("Some notification features require Premium")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HabitSettingsView: View {
    var body: some View {
        List {
            Section("Current Habit") {
                HStack {
                    Text("Habit Type")
                    Spacer()
                    Text("Nail Biting")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Target Days")
                    Spacer()
                    Text("21")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Started")
                    Spacer()
                    Text("18 days ago")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Actions") {
                Button("Edit Habit Details") {
                    // TODO: Show habit editing sheet
                }
                
                Button("Reset Streak") {
                    // TODO: Show confirmation dialog
                }
                .foregroundColor(.orange)
                
                Button("Archive Habit") {
                    // TODO: Show confirmation dialog
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Habit Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon and Name
                VStack(spacing: 16) {
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("QuitIt")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Break free from bad habits")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 16) {
                    Text("About QuitIt")
                        .font(.headline)
                    
                    Text("QuitIt helps you break body-focused repetitive behaviors (BFRBs) like nail biting, skin picking, and hair pulling through mindful tracking, personalized insights, and supportive reminders.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Our evidence-based approach combines behavioral tracking with positive reinforcement to help you build lasting change.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features")
                        .font(.headline)
                    
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Track your progress with detailed analytics")
                    FeatureRow(icon: "lightbulb.fill", text: "Get personalized insights and tips")
                    FeatureRow(icon: "bell.fill", text: "Receive gentle reminders and motivation")
                    FeatureRow(icon: "photo.fill", text: "Document your journey with photos")
                }
                
                // Contact
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contact")
                        .font(.headline)
                    
                    Link("support@quitit.app", destination: URL(string: "mailto:support@quitit.app")!)
                        .foregroundColor(.blue)
                    
                    Link("quitit.app", destination: URL(string: "https://quitit.app")!)
                        .foregroundColor(.blue)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserSettings.shared)
}
