//
//  InsightsView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import CoreData

struct InsightsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var insightsViewModel: InsightsViewModel
    
    init(viewContext: NSManagedObjectContext) {
        self._insightsViewModel = StateObject(wrappedValue: InsightsViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Personal Insights
                    PersonalInsightsView(viewModel: insightsViewModel)
                    
                    // Trigger Analysis
                    TriggerAnalysisView(viewModel: insightsViewModel)
                    
                    // Pattern Recognition
                    PatternRecognitionView(viewModel: insightsViewModel)
                    
                    // Tips & Strategies
                    TipsStrategiesView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .navigationTitle("Insights")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct PersonalInsightsView: View {
    let viewModel: InsightsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Insights")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                InsightCard(
                    icon: "clock.fill",
                    title: "Peak Urge Time",
                    insight: viewModel.peakUrgeTime,
                    suggestion: "Schedule a mindful activity during this time"
                )
                
                InsightCard(
                    icon: "brain.head.profile",
                    title: "Top Trigger",
                    insight: "\(viewModel.topTrigger) (\(viewModel.topTriggerPercentage)% of urges)",
                    suggestion: "Try deep breathing when feeling stressed"
                )
                
                InsightCard(
                    icon: "calendar.badge.plus",
                    title: "Weekly Pattern",
                    insight: viewModel.weeklyPattern,
                    suggestion: "Plan ahead for high-urge days"
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let insight: String
    let suggestion: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(insight)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(suggestion)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .italic()
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct TriggerAnalysisView: View {
    let viewModel: InsightsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Trigger Analysis")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                ForEach(viewModel.triggerAnalysis, id: \.trigger) { analysis in
                    TriggerRow(
                        trigger: analysis.trigger,
                        percentage: analysis.percentage,
                        color: analysis.percentage > 50 ? .red : analysis.percentage > 25 ? .orange : .yellow
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct TriggerRow: View {
    let trigger: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(trigger)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.tertiarySystemBackground))
                    .frame(width: 100, height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(color)
                    .frame(width: CGFloat(percentage), height: 8)
                    .cornerRadius(4)
            }
            
            Text("\(percentage)%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct PatternRecognitionView: View {
    let viewModel: InsightsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Patterns & Trends")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                PatternCard(
                    title: "Weekly Pattern",
                    description: viewModel.weeklyPattern,
                    trend: "📅 Weekly Analysis"
                )
                
                PatternCard(
                    title: "Success Rate",
                    description: "You've successfully redirected \(Int(viewModel.successRate * 100))% of urges",
                    trend: "✅ Progress Tracking"
                )
                
                PatternCard(
                    title: "Average Intensity",
                    description: String(format: "Average urge intensity: %.1f/10", viewModel.averageIntensity),
                    trend: "📊 Intensity Analysis"
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PatternCard: View {
    let title: String
    let description: String
    let trend: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(trend)
                .font(.caption)
                .foregroundColor(.blue)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct TipsStrategiesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Personalized Tips")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                TipCard(
                    category: "For Stress",
                    tip: "Try the 4-7-8 breathing technique when you feel stressed",
                    icon: "lungs.fill",
                    color: .blue
                )
                
                TipCard(
                    category: "For Boredom",
                    tip: "Keep a fidget toy or stress ball nearby for idle moments",
                    icon: "gamecontroller.fill",
                    color: .green
                )
                
                TipCard(
                    category: "General",
                    tip: "Reward yourself for each successful day with something you enjoy",
                    icon: "gift.fill",
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

struct TipCard: View {
    let category: String
    let tip: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .textCase(.uppercase)
                
                Text(tip)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    InsightsView(viewContext: PersistenceController.preview().container.viewContext)
}
