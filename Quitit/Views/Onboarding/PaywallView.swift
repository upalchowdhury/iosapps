//
//  PaywallView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            VStack(spacing: 16) {
                Text("Unlock Your Full Potential")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Get premium features to maximize your success")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            // Premium Features
            VStack(alignment: .leading, spacing: 16) {
                PremiumFeatureRow(icon: "photo.fill", text: "Photo progress tracking")
                PremiumFeatureRow(icon: "chart.bar.fill", text: "Advanced analytics & insights")
                PremiumFeatureRow(icon: "bell.fill", text: "Custom reminder schedules")
                PremiumFeatureRow(icon: "square.and.arrow.up.fill", text: "Export your data")
                PremiumFeatureRow(icon: "applewatch", text: "Apple Watch companion")
                PremiumFeatureRow(icon: "widget.small.fill", text: "Home screen widgets")
            }
            .padding(.horizontal, 40)
            
            // Subscription Options
            VStack(spacing: 12) {
                SubscriptionOptionCard(
                    title: "Yearly",
                    price: "$59.99",
                    period: "per year",
                    savings: "Save 50%",
                    isRecommended: true
                )
                
                SubscriptionOptionCard(
                    title: "Monthly",
                    price: "$9.99",
                    period: "per month",
                    savings: nil,
                    isRecommended: false
                )
                
                SubscriptionOptionCard(
                    title: "Weekly",
                    price: "$2.99",
                    period: "per week",
                    savings: nil,
                    isRecommended: false
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // CTA Buttons
            VStack(spacing: 16) {
                Button(action: {
                    onComplete()
                }) {
                    Text("Start 7-Day Free Trial")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                Button(action: onSkip) {
                    Text("Maybe Later")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 20) {
                    Button("Terms of Service") {
                        // Opens terms in Safari
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    
                    Button("Restore Purchases") {
                        // Restore purchases functionality
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

struct PremiumFeatureRow: View {
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

struct SubscriptionOptionCard: View {
    let title: String
    let price: String
    let period: String
    let savings: String?
    let isRecommended: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if isRecommended {
                        Text("BEST VALUE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.white)
                            .cornerRadius(4)
                    }
                }
                
                if let savings = savings {
                    Text(savings)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(price)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(period)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(isRecommended ? 0.3 : 0.2))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecommended ? Color.white : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    PaywallView(onComplete: {}, onSkip: {})
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
