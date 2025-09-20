//
//  DashboardView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var dashboardViewModel: DashboardViewModel
    @State private var showingSOSModal = false
    @State private var sosCountdown = 60
    @State private var sosTimer: Timer?
    
    init(viewContext: NSManagedObjectContext) {
        self._dashboardViewModel = StateObject(wrappedValue: DashboardViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        headerSection
                        
                        // Main Content
                        VStack(spacing: 24) {
                            // Streak Display
                            streakSection
                            
                            // If-Then Plan Display
                            planSection
                            
                            // Quick Actions
                            quickActionsSection
                            
                            // Coach Section
                            coachSection
                            
                            // Today's Stats
                            todaysStatsSection
                            
                            // Recent Activity
                            recentActivitySection
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $dashboardViewModel.showingUrgeLogSheet) {
            UrgeLogSheet(viewModel: dashboardViewModel)
        }
        .sheet(isPresented: $dashboardViewModel.showingCheckInSheet) {
            CheckInSheet(viewModel: dashboardViewModel)
        }
        .overlay {
            if showingSOSModal {
                sosModalOverlay
            }
        }
        .onAppear {
            // Refresh data when view appears
        }
    }
    
    private var headerSection: some View {
        HStack {
            Spacer()
            
            Text("Dashboard")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(
            HStack {
                Spacer()
                
                Button(action: {
                    // Settings action
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .frame(width: 44, height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
        )
    }
    
    private var streakSection: some View {
        VStack(spacing: 16) {
            // Current Streak with badges
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Text("\(dashboardViewModel.currentStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.indigo)
                }
                
                Text("Day Streak")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                // Achievement badges
                HStack(spacing: 12) {
                    // Streak freeze badge
                    HStack(spacing: 4) {
                        Image(systemName: "snowflake")
                            .font(.caption)
                        Text("2")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
                    
                    // Improvement badge
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.caption)
                        Text("-2 urges vs last week")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var planSection: some View {
        // If-Then Plan Display
        VStack(alignment: .leading, spacing: 16) {
            Text("If-Then Plan")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .font(.title)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("If I feel the urge to smoke, then I will go for a 10-minute walk.")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Review and update your plan regularly to stay on track.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
        }
    }
    
    private var quickActionsSection: some View {
        // Quick Actions
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                Button(action: {
                    print("DASHBOARD LOG URGE BUTTON TAPPED!")
                    dashboardViewModel.showingUrgeLogSheet = true
                    print("Dashboard sheet flag set to: \(dashboardViewModel.showingUrgeLogSheet)")
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        Text("Log Urge")
                            .font(.caption)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                QuickActionButton(
                    title: "Daily Check-in",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    action: {
                        dashboardViewModel.showingCheckInSheet = true
                    }
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var coachSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Coach")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                Image(systemName: "megaphone.fill")
                    .font(.title)
                    .foregroundColor(.indigo)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your urges seem to spike between 3–5 PM.")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Consider scheduling a 3:00 PM walk to get ahead of it.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
        }
    }
    
    private var todaysStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Stats")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(
                    title: "Urges Resisted",
                    value: "\(dashboardViewModel.todayUrgesResisted)",
                    color: .primary
                )
                
                StatCard(
                    title: "Total Urges",
                    value: "\(dashboardViewModel.todayTotalUrges)",
                    color: .primary
                )
                
                StatCard(
                    title: "Success Rate",
                    value: "\(Int((Double(dashboardViewModel.todayUrgesResisted) / Double(max(dashboardViewModel.todayTotalUrges, 1))) * 100))%",
                    color: .primary
                )
                
                StatCard(
                    title: "Avg Intensity",
                    value: String(format: "%.1f", dashboardViewModel.todayAverageIntensity),
                    color: .primary
                )
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Urges")
                .font(.title2)
                .fontWeight(.bold)
            
            if dashboardViewModel.recentActivity.isEmpty {
                VStack(spacing: 12) {
                    Text("No urges logged yet today. Keep it up!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(dashboardViewModel.recentActivity.prefix(3)), id: \.self) { activity in
                        UrgeLogRow(activity: activity)
                    }
                }
            }
        }
    }
    
    private var sosModalOverlay: some View {
        // SOS Modal Overlay
        ZStack {
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack {
                Text("SOS")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You're doing great! Keep it up.")
                    .font(.headline)
                
                Button("Dismiss") {
                    showingSOSModal = false
                }
                .padding()
                .background(Color(.systemBlue))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct UrgeLogRow: View {
    let activity: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(activity.contains("Resisted") ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("Just now")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MotivationalQuoteCard: View {
    @State private var quote = "Every urge resisted is a step toward freedom"
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "quote.bubble.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(quote)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .italic()
            
            Text("— Daily Motivation")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DashboardView(viewContext: PersistenceController.preview().container.viewContext)
}
