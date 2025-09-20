//
//  UserSettings.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    private init() {}
    
    // Onboarding
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { 
            UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding")
            objectWillChange.send()
        }
    }
    
    // Notifications
    var notificationsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "notificationsEnabled") }
        set { 
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
            objectWillChange.send()
        }
    }
    
    var morningReminderTime: Date {
        get { 
            if let data = UserDefaults.standard.data(forKey: "morningReminderTime"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                return date
            }
            return Self.createDefaultTime(hour: 9)
        }
        set { 
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "morningReminderTime")
                objectWillChange.send()
            }
        }
    }
    
    var middayReminderTime: Date {
        get { 
            if let data = UserDefaults.standard.data(forKey: "middayReminderTime"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                return date
            }
            return Self.createDefaultTime(hour: 14)
        }
        set { 
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "middayReminderTime")
                objectWillChange.send()
            }
        }
    }
    
    var eveningReminderTime: Date {
        get { 
            if let data = UserDefaults.standard.data(forKey: "eveningReminderTime"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                return date
            }
            return Self.createDefaultTime(hour: 21)
        }
        set { 
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "eveningReminderTime")
                objectWillChange.send()
            }
        }
    }
    
    // Premium
    var isPremiumUser: Bool {
        get { UserDefaults.standard.bool(forKey: "isPremiumUser") }
        set { 
            UserDefaults.standard.set(newValue, forKey: "isPremiumUser")
            objectWillChange.send()
        }
    }
    
    var subscriptionExpiryDate: Date? {
        get { 
            if let data = UserDefaults.standard.data(forKey: "subscriptionExpiryDate"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                return date
            }
            return nil
        }
        set { 
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "subscriptionExpiryDate")
            } else {
                UserDefaults.standard.removeObject(forKey: "subscriptionExpiryDate")
            }
            objectWillChange.send()
        }
    }
    
    // App Usage
    var launchCount: Int {
        get { UserDefaults.standard.integer(forKey: "launchCount") }
        set { 
            UserDefaults.standard.set(newValue, forKey: "launchCount")
            objectWillChange.send()
        }
    }
    
    var lastReviewPromptDate: Date? {
        get { 
            if let data = UserDefaults.standard.data(forKey: "lastReviewPromptDate"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                return date
            }
            return nil
        }
        set { 
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "lastReviewPromptDate")
            } else {
                UserDefaults.standard.removeObject(forKey: "lastReviewPromptDate")
            }
            objectWillChange.send()
        }
    }
    
    private static func createDefaultTime(hour: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = 0
        return calendar.date(from: components) ?? Date()
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
