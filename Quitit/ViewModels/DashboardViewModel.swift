//
//  DashboardViewModel.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import Foundation
import CoreData

final class DashboardViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    private let habitRepo: HabitRepository
    private let urgeRepo: UrgeRepository
    private let checkInRepo: CheckInRepository
    
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var targetDays: Int = 21
    @Published var totalUrgesResisted: Int = 0
    
    @Published var todayUrgesResisted: Int = 0
    @Published var todayTotalUrges: Int = 0
    @Published var todayAverageIntensity: Double = 0.0
    
    @Published var recentActivity: [String] = []
    
    @Published var showingUrgeLogSheet = false
    @Published var showingCheckInSheet = false
    @Published var isLoading = false
    
    @Published var activeHabit: Habit?
    
    init(viewContext: NSManagedObjectContext, 
         habitRepo: HabitRepository = CoreDataHabitRepository(),
         urgeRepo: UrgeRepository = CoreDataUrgeRepository(),
         checkInRepo: CheckInRepository = CoreDataCheckInRepository()) {
        self.viewContext = viewContext
        self.habitRepo = habitRepo
        self.urgeRepo = urgeRepo
        self.checkInRepo = checkInRepo
        
        loadData()
    }
    
    func loadData() {
        do {
            activeHabit = try habitRepo.activeHabit(ctx: viewContext)
            
            if let habit = activeHabit {
                currentStreak = Int(habit.currentStreak)
                longestStreak = Int(habit.longestStreak)
                targetDays = Int(habit.targetDays)
                totalUrgesResisted = Int(habit.totalUrgesResisted)
                
                let stats = try urgeRepo.todayStats(for: habit, ctx: viewContext)
                todayUrgesResisted = stats.resisted
                todayTotalUrges = stats.total
                todayAverageIntensity = stats.avgIntensity
                
                loadRecentActivity()
            }
        } catch {
            print("Failed to load dashboard data: \(error)")
        }
    }
    
    private func loadRecentActivity() {
        guard let habit = activeHabit else { return }
        
        let req: NSFetchRequest<UrgeLog> = UrgeLog.fetchRequest()
        req.predicate = NSPredicate(format: "habit == %@", habit)
        req.sortDescriptors = [NSSortDescriptor(keyPath: \UrgeLog.timestamp, ascending: false)]
        req.fetchLimit = 10
        
        do {
            let logs = try viewContext.fetch(req)
            recentActivity = logs.compactMap { log in
                guard let state = log.state, let timestamp = log.timestamp else { return nil }
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                let timeString = formatter.string(from: timestamp)
                
                switch state {
                case "redirected":
                    return "Resisted urge at \(timeString)"
                case "notYet":
                    return "Logged urge at \(timeString)"
                case "paused":
                    return "Paused at \(timeString)"
                default:
                    return "Activity at \(timeString)"
                }
            }
        } catch {
            print("Failed to load recent activity: \(error)")
        }
    }
    
    func logUrge(intensity: Double, technique: String, duration: Int, triggers: [String], location: String, notes: String, wasResisted: Bool) {
        guard let habit = activeHabit else { return }
        
        do {
            let state: UrgeState = wasResisted ? .redirected : .notYet
            let triggerString = triggers.isEmpty ? nil : triggers.joined(separator: ", ")
            
            _ = try urgeRepo.logUrge(
                for: habit,
                intensity: Int(intensity),
                state: state,
                trigger: triggerString,
                technique: technique.isEmpty ? nil : technique,
                location: location.isEmpty ? nil : location,
                duration: duration > 0 ? duration : nil,
                note: notes.isEmpty ? nil : notes,
                at: Date(),
                ctx: viewContext
            )
            
            loadData() // Refresh data
            showingUrgeLogSheet = false
        } catch {
            print("Failed to log urge: \(error)")
        }
    }
    
    func saveCheckIn(mood: Int, hasPhoto: Bool, journalEntry: String, wasSuccessful: Bool, photoPath: String? = nil) {
        guard let habit = activeHabit else { return }
        
        do {
            _ = try checkInRepo.createCheckIn(
                for: habit,
                date: Date(),
                isSuccessful: wasSuccessful,
                photoPath: photoPath,
                journalEntry: journalEntry.isEmpty ? nil : journalEntry,
                moodRating: mood,
                ctx: viewContext
            )
            
            loadData() // Refresh data
            showingCheckInSheet = false
        } catch {
            print("Failed to save check-in: \(error)")
        }
    }
}
