//
//  Constants.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import UIKit

struct Constants {
    
    // MARK: - Design System
    struct Colors {
        static let primary = Color.blue
        static let success = Color.green
        static let warning = Color.orange
        static let danger = Color.red
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
        
        // Gradient colors
        static let primaryGradient = LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let successGradient = LinearGradient(
            colors: [Color.green.opacity(0.8), Color.mint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    struct ButtonHeight {
        static let standard: CGFloat = 50
        static let compact: CGFloat = 40
        static let large: CGFloat = 60
    }
    
    // MARK: - Subscription
    struct Subscription {
        static let weeklyProductID = "quitit_weekly_299"
        static let monthlyProductID = "quitit_monthly_999"
        static let yearlyProductID = "quitit_yearly_5999"
        static let freeTrialDays = 7
    }
    
    // MARK: - Notifications
    struct NotificationIdentifiers {
        static let morningMotivation = "morning_motivation"
        static let middayCheck = "midday_check"
        static let eveningReflection = "evening_reflection"
        static let streakMilestone = "streak_milestone"
        static let highRiskAlert = "high_risk_alert"
    }
    
    // MARK: - Analytics
    struct AnalyticsEvents {
        static let appLaunched = "app_launched"
        static let habitCreated = "habit_created"
        static let urgeLogged = "urge_logged"
        static let urgeResisted = "urge_resisted"
        static let streakMilestone = "streak_milestone"
        static let subscriptionStarted = "subscription_started"
        static let onboardingCompleted = "onboarding_completed"
    }
    
    // MARK: - Limits
    struct Limits {
        static let freeHabitsLimit = 1
        static let maxHabitsForPremium = 10
        static let reviewPromptThreshold = 10 // launches
        static let reviewPromptCooldown: TimeInterval = 30 * 24 * 60 * 60 // 30 days
    }
}
