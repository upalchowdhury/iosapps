//
//  ProgressView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar View
                    CalendarCardView()
                    
                    // Statistics Overview
                    StatisticsOverviewView()
                    
                    // Charts Section
                    ChartsView()
                    
                    // Photo Timeline (Premium)
                    PhotoTimelineView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .navigationTitle("Progress")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct CalendarCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Habit Calendar")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Calendar grid - shows real data when available
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(1...28, id: \.self) { day in
                    CalendarDayCell(day: day, status: .noData)
                }
            }
            
            // Legend
            HStack(spacing: 16) {
                LegendItem(color: .green, text: "Success")
                LegendItem(color: .red, text: "Reset")
                LegendItem(color: .gray, text: "No data")
            }
            .font(.caption)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
}

struct CalendarDayCell: View {
    let day: Int
    let status: DayStatus
    
    var body: some View {
        Text("\(day)")
            .font(.caption)
            .foregroundColor(status == .noData ? .secondary : .white)
            .frame(width: 32, height: 32)
            .background(status.color)
            .cornerRadius(8)
    }
}

enum DayStatus {
    case success, reset, noData
    
    var color: Color {
        switch self {
        case .success: return .green
        case .reset: return .red
        case .noData: return .gray.opacity(0.3)
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
        }
    }
}

struct StatisticsOverviewView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Progress")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ProgressStatCard(
                    title: "Total Days",
                    value: "0",
                    subtitle: "Since starting",
                    color: .blue
                )
                
                ProgressStatCard(
                    title: "Success Rate",
                    value: "0%",
                    subtitle: "Overall",
                    color: .green
                )
                
                ProgressStatCard(
                    title: "Urges Resisted",
                    value: "0",
                    subtitle: "Total count",
                    color: .orange
                )
                
                ProgressStatCard(
                    title: "Best Streak",
                    value: "0",
                    subtitle: "Days in a row",
                    color: .purple
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ChartsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Trends & Patterns")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Charts - will show data when available
            VStack(spacing: 12) {
                ChartPlaceholder(title: "Urge Frequency", subtitle: "Start logging to see trends")
                ChartPlaceholder(title: "Intensity Trends", subtitle: "Track patterns over time")
                ChartPlaceholder(title: "Time Patterns", subtitle: "Discover your triggers")
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ChartPlaceholder: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("View") {
                    // TODO: Show detailed chart
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // Chart area - populated with real data
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    Text("No data yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                )
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct PhotoTimelineView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Photo Progress")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
            
            // Premium feature placeholder
            VStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                Text("Track Visual Progress")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Take photos to see your improvement over time")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Upgrade to Premium") {
                    // TODO: Show paywall
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding(.vertical, 20)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ProgressView()
}
