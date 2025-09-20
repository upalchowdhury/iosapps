//
//  NotificationService.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import Foundation
import UserNotifications

@Observable
final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    // MARK: - Permission Management
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            return granted
        } catch {
            print("Failed to request notification permission: \(error)")
            return false
        }
    }
    
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Daily Reminders
    func scheduleDefaultNotifications() {
        let userSettings = UserSettings.shared
        
        scheduleMorningMotivation(at: userSettings.morningReminderTime)
        scheduleMiddayCheck(at: userSettings.middayReminderTime)
        scheduleEveningReflection(at: userSettings.eveningReminderTime)
    }
    
    private func scheduleMorningMotivation(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning! 🌅"
        content.body = "Start your day strong. You've got this!"
        content.sound = .default
        content.categoryIdentifier = "MOTIVATION"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "morning_motivation",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule morning notification: \(error)")
            }
        }
    }
    
    private func scheduleMiddayCheck(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Midday Check-in 🕐"
        content.body = "How are you doing? Take a moment to check in with yourself."
        content.sound = .default
        content.categoryIdentifier = "CHECK_IN"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "midday_check",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule midday notification: \(error)")
            }
        }
    }
    
    private func scheduleEveningReflection(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Evening Reflection 🌙"
        content.body = "Time for your daily check-in. How did today go?"
        content.sound = .default
        content.categoryIdentifier = "REFLECTION"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "evening_reflection",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule evening notification: \(error)")
            }
        }
    }
    
    // MARK: - Smart Alerts
    func scheduleStreakMilestone(streak: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Streak Milestone! 🎉"
        content.body = "Congratulations! You've reached \(streak) days. Keep going!"
        content.sound = .default
        content.categoryIdentifier = "MILESTONE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "streak_\(streak)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule milestone notification: \(error)")
            }
        }
    }
    
    func scheduleHighRiskAlert(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Stay Strong 💪"
        content.body = "This is typically a challenging time for you. Remember your goals!"
        content.sound = .default
        content.categoryIdentifier = "HIGH_RISK"
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "high_risk_\(time.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule high-risk notification: \(error)")
            }
        }
    }
    
    // MARK: - Interactive Notifications
    func setupNotificationCategories() {
        let motivationCategory = UNNotificationCategory(
            identifier: "MOTIVATION",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        let checkInAction = UNNotificationAction(
            identifier: "CHECK_IN_ACTION",
            title: "Quick Check-in",
            options: [.foreground]
        )
        
        let checkInCategory = UNNotificationCategory(
            identifier: "CHECK_IN",
            actions: [checkInAction],
            intentIdentifiers: [],
            options: []
        )
        
        let logUrgeAction = UNNotificationAction(
            identifier: "LOG_URGE_ACTION",
            title: "Log Urge",
            options: [.foreground]
        )
        
        let highRiskCategory = UNNotificationCategory(
            identifier: "HIGH_RISK",
            actions: [logUrgeAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            motivationCategory,
            checkInCategory,
            highRiskCategory
        ])
    }
    
    // MARK: - Management
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
}
