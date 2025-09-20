//
//  View+Extensions.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View {
    // MARK: - Card Style
    func cardStyle(backgroundColor: Color = Constants.Colors.background) -> some View {
        self
            .padding(Constants.Spacing.md)
            .background(backgroundColor)
            .cornerRadius(Constants.CornerRadius.md)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Button Styles
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: Constants.ButtonHeight.standard)
            .background(Constants.Colors.primaryGradient)
            .cornerRadius(Constants.CornerRadius.md)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(Constants.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: Constants.ButtonHeight.standard)
            .background(Constants.Colors.primary.opacity(0.1))
            .cornerRadius(Constants.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.md)
                    .stroke(Constants.Colors.primary, lineWidth: 1)
            )
    }
    
    // MARK: - Card Styles
    func streakCardStyle() -> some View {
        self
            .padding(Constants.Spacing.lg)
            .background(Constants.Colors.successGradient)
            .cornerRadius(Constants.CornerRadius.lg)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
    
    func statCardStyle() -> some View {
        self
            .padding(Constants.Spacing.md)
            .background(Constants.Colors.background)
            .cornerRadius(Constants.CornerRadius.md)
            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Haptic Feedback
    #if canImport(UIKit)
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
    }
    #else
    func hapticFeedback(_ style: Int = 0) -> some View {
        self // No-op for non-iOS platforms
    }
    #endif
    
    // MARK: - Keyboard Handling
    func hideKeyboard() -> some View {
        #if canImport(UIKit)
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        #else
        return self
        #endif
    }
    
    // MARK: - Navigation
    func navigationBarStyle() -> some View {
        self
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Constants.Colors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    #if canImport(UIKit)
    func hideNavigationBar() -> some View {
        self.navigationBarHidden(true)
    }
    #else
    func hideNavigationBar() -> some View {
        self.toolbar(.hidden, for: .navigationBar)
    }
    #endif
    
    func dismissKeyboard() -> some View {
        #if canImport(UIKit)
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        #else
        return self
        #endif
    }
    
    // MARK: - Conditional Modifiers
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - Loading State
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
                .cornerRadius(Constants.CornerRadius.md)
            }
        }
    }
}
