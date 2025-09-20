//
//  WelcomeView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct WelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Icon/Illustration
            Image(systemName: "hands.sparkles.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            // App Name and Tagline
            VStack(spacing: 16) {
                Text("QuitIt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Break free from bad habits")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            
            // Social Proof
            Text("Join 50,000+ people breaking bad habits")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // CTA Button
            Button(action: onNext) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    WelcomeView(onNext: {})
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
