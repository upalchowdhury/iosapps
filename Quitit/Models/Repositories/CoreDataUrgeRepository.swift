import CoreData
import Foundation

final class CoreDataUrgeRepository: UrgeRepository {
    func logUrge(for habit: Habit, intensity: Int, state: UrgeState,
                 trigger: String?, technique: String?, location: String?, duration: Int?,
                 note: String?, at date: Date = Date(), ctx: NSManagedObjectContext) throws -> UrgeLog {
        let log = UrgeLog(context: ctx)
        log.id = UUID()
        log.timestamp = date
        log.intensity = Int16(intensity)
        log.state = state.rawValue
        log.triggerNote = trigger
        log.technique = technique
        log.location = location
        if let duration = duration {
            log.duration = Int32(duration)
        }
        log.note = note
        log.habit = habit

        try updateStreaks(for: habit, with: state, at: date)
        try ctx.save()
        return log
    }

    private func updateStreaks(for habit: Habit, with state: UrgeState, at date: Date) throws {
        switch state {
        case .redirected:
            habit.totalUrgesResisted += 1
            if !Calendar.current.isDateInToday(habit.lastResetDate ?? .distantPast) {
                habit.currentStreak += 1
                habit.longestStreak = max(habit.longestStreak, habit.currentStreak)
            }
        case .notYet:
            habit.currentStreak = 0
            habit.lastResetDate = date
        case .paused:
            break
        }
    }

    func todayStats(for habit: Habit, ctx: NSManagedObjectContext)
      throws -> (resisted: Int, total: Int, avgIntensity: Double) {
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let req: NSFetchRequest<UrgeLog> = UrgeLog.fetchRequest()
        req.predicate = NSPredicate(format: "habit == %@ AND timestamp >= %@ AND timestamp < %@",
                                    habit, start as NSDate, end as NSDate)
        let logs = try ctx.fetch(req)
        let total = logs.count
        let resisted = logs.filter { $0.state == UrgeState.redirected.rawValue }.count
        let avg = logs.isEmpty ? 0 : Double(logs.map { Int($0.intensity) }.reduce(0, +)) / Double(total)
        return (resisted, total, avg)
    }
    
    func allUrges(for habit: Habit, ctx: NSManagedObjectContext) throws -> [UrgeLog] {
        let req: NSFetchRequest<UrgeLog> = UrgeLog.fetchRequest()
        req.predicate = NSPredicate(format: "habit == %@", habit)
        req.sortDescriptors = [NSSortDescriptor(keyPath: \UrgeLog.timestamp, ascending: false)]
        return try ctx.fetch(req)
    }
}
