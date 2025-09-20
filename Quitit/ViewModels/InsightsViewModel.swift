//
//  InsightsViewModel.swift
//  QuitIt
//
//  Created by Upalc on 9/16/25.
//

import Foundation
import CoreData
import SwiftUI

final class InsightsViewModel: ObservableObject {
    private let habitRepo: HabitRepository
    private let urgeRepo: UrgeRepository
    private let viewContext: NSManagedObjectContext
    
    // Published properties for UI
    @Published var activeHabit: Habit?
    @Published var peakUrgeTime: String = "Loading..."
    @Published var topTrigger: String = "Loading..."
    @Published var topTriggerPercentage: Int = 0
    @Published var bestDay: String = "Loading..."
    @Published var triggerAnalysis: [TriggerData] = []
    @Published var weeklyPattern: String = "Loading..."
    @Published var intensityTrend: String = "Loading..."
    @Published var successRate: Double = 0.0
    @Published var averageIntensity: Double = 0.0
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.habitRepo = CoreDataHabitRepository()
        self.urgeRepo = CoreDataUrgeRepository()
        loadInsights()
    }
    
    func loadInsights() {
        do {
            activeHabit = try habitRepo.activeHabit(ctx: viewContext)
            
            guard let habit = activeHabit else {
                setNoDataState()
                return
            }
            
            loadPeakUrgeTime(for: habit)
            loadTriggerAnalysis(for: habit)
            loadWeeklyPatterns(for: habit)
            loadSuccessMetrics(for: habit)
            
        } catch {
            print("Failed to load insights: \(error)")
            setNoDataState()
        }
    }
    
    private func loadPeakUrgeTime(for habit: Habit) {
        do {
            let urgeLogs = try urgeRepo.allUrges(for: habit, ctx: viewContext)
            
            if urgeLogs.isEmpty {
                peakUrgeTime = "No data yet"
                return
            }
            
            // Group urges by hour
            let hourCounts = Dictionary(grouping: urgeLogs) { urgeLog in
                Calendar.current.component(.hour, from: urgeLog.timestamp ?? Date())
            }.mapValues { $0.count }
            
            if let peakHour = hourCounts.max(by: { $0.value < $1.value })?.key {
                let formatter = DateFormatter()
                formatter.dateFormat = "h a"
                let date = Calendar.current.date(bySettingHour: peakHour, minute: 0, second: 0, of: Date()) ?? Date()
                peakUrgeTime = "Most urges around \(formatter.string(from: date))"
            } else {
                peakUrgeTime = "No clear pattern yet"
            }
        } catch {
            peakUrgeTime = "Unable to analyze"
        }
    }
    
    private func loadTriggerAnalysis(for habit: Habit) {
        do {
            let urgeLogs = try urgeRepo.allUrges(for: habit, ctx: viewContext)
            
            if urgeLogs.isEmpty {
                topTrigger = "No data yet"
                triggerAnalysis = []
                return
            }
            
            // Count triggers
            let triggerCounts = Dictionary(grouping: urgeLogs.compactMap { $0.triggerNote }) { $0 }
                .mapValues { $0.count }
            
            let totalUrges = urgeLogs.count
            
            if let mostCommonTrigger = triggerCounts.max(by: { $0.value < $1.value }) {
                topTrigger = mostCommonTrigger.key
                topTriggerPercentage = Int((Double(mostCommonTrigger.value) / Double(totalUrges)) * 100)
            }
            
            // Create trigger analysis data
            triggerAnalysis = triggerCounts.sorted { $0.value > $1.value }
                .prefix(5)
                .map { trigger, count in
                    let percentage = Int((Double(count) / Double(totalUrges)) * 100)
                    return TriggerData(
                        trigger: trigger,
                        percentage: percentage
                    )
                }
        } catch {
            topTrigger = "Unable to analyze"
            triggerAnalysis = []
        }
    }
    
    private func loadWeeklyPatterns(for habit: Habit) {
        do {
            let urgeLogs = try urgeRepo.allUrges(for: habit, ctx: viewContext)
            
            if urgeLogs.isEmpty {
                weeklyPattern = "No data yet"
                return
            }
            
            // Group by weekday
            let weekdayCounts = Dictionary(grouping: urgeLogs) { urgeLog in
                Calendar.current.component(.weekday, from: urgeLog.timestamp ?? Date())
            }.mapValues { $0.count }
            
            if let peakWeekday = weekdayCounts.max(by: { $0.value < $1.value })?.key {
                let dayName = Calendar.current.weekdaySymbols[peakWeekday - 1]
                weeklyPattern = "Most urges occur on \(dayName)s"
            } else {
                weeklyPattern = "No clear weekly pattern"
            }
        } catch {
            weeklyPattern = "Unable to analyze"
        }
    }
    
    private func loadSuccessMetrics(for habit: Habit) {
        do {
            let urgeLogs = try urgeRepo.allUrges(for: habit, ctx: viewContext)
            
            if urgeLogs.isEmpty {
                intensityTrend = "No data yet"
                successRate = 0.0
                averageIntensity = 0.0
                return
            }
            
            // Calculate success rate (redirected urges)
            let successfulUrges = urgeLogs.filter { $0.state == "redirected" }.count
            let totalUrges = urgeLogs.count
            successRate = totalUrges > 0 ? Double(successfulUrges) / Double(totalUrges) : 0.0
            
            // Calculate average intensity
            let intensities = urgeLogs.map { Double($0.intensity) }
            averageIntensity = intensities.isEmpty ? 0.0 : intensities.reduce(0, +) / Double(intensities.count)
            
            // Calculate intensity trend
            let recentUrges = urgeLogs.sorted { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }.prefix(10)
            let olderUrges = urgeLogs.sorted { ($0.timestamp ?? Date()) < ($1.timestamp ?? Date()) }.prefix(10)
            
            if !recentUrges.isEmpty && !olderUrges.isEmpty {
                let recentAvg = recentUrges.map { Int($0.intensity) }.reduce(0, +) / recentUrges.count
                let olderAvg = olderUrges.map { Int($0.intensity) }.reduce(0, +) / olderUrges.count
                
                if recentAvg < olderAvg {
                    intensityTrend = "📉 Intensity decreasing (good progress!)"
                } else if recentAvg > olderAvg {
                    intensityTrend = "📈 Intensity increasing (stay focused)"
                } else {
                    intensityTrend = "➡️ Intensity stable"
                }
            } else {
                intensityTrend = "Need more data for trend analysis"
            }
        } catch {
            intensityTrend = "Unable to analyze"
            successRate = 0.0
            averageIntensity = 0.0
        }
    }
    
    private func getTriggerColor(for trigger: String) -> Color {
        switch trigger.lowercased() {
        case let t where t.contains("stress"): return .red
        case let t where t.contains("bored"): return .orange
        case let t where t.contains("anxious"): return .yellow
        case let t where t.contains("tired"): return .blue
        default: return .gray
        }
    }
    
    private func setNoDataState() {
        peakUrgeTime = "Create a habit to see insights"
        topTrigger = "No data available"
        topTriggerPercentage = 0
        bestDay = "No data available"
        triggerAnalysis = []
        weeklyPattern = "No data available"
        intensityTrend = "No data available"
        successRate = 0.0
        averageIntensity = 0.0
    }
}

struct TriggerData: Identifiable {
    let id = UUID()
    let trigger: String
    let percentage: Int
}
