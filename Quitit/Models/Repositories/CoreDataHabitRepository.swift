import Foundation
import CoreData
import OSLog

final class CoreDataHabitRepository: HabitRepository {
    private let log = Logger(subsystem: "com.quitit.app", category: "HabitRepository")

    func activeHabit(ctx: NSManagedObjectContext) throws -> Habit? {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "isActive == true")
        req.fetchLimit = 1
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)]
        return try ctx.fetch(req).first
    }

    @discardableResult
    func createHabit(name: String, type: String, makeActive: Bool = true, ctx: NSManagedObjectContext) throws -> Habit {
        var result: Habit!
        try ctx.performAndWait {
            if makeActive {
                try? self.deactivateAll(ctx: ctx)
            }
            let h = Habit(context: ctx)
            h.id = UUID()
            h.name = name
            h.type = type
            h.createdDate = Date()
            h.isActive = makeActive
            h.currentStreak = 0
            h.longestStreak = 0
            h.totalUrgesResisted = 0
            h.targetDays = 21
            try ctx.save()
            result = h
            log.info("Created habit \(name, privacy: .public) type=\(type, privacy: .public) active=\(makeActive ? "true" : "false")")
        }
        return result
    }

    func setActive(_ habit: Habit, ctx: NSManagedObjectContext) throws {
        try ctx.performAndWait {
            try self.deactivateAll(ctx: ctx)
            habit.isActive = true
            try ctx.save()
            log.info("Set active habit \(habit.name ?? "Unnamed", privacy: .public)")
        }
    }

    func allHabits(ctx: NSManagedObjectContext) throws -> [Habit] {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.sortDescriptors = [
            NSSortDescriptor(keyPath: \Habit.isActive, ascending: false),
            NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)
        ]
        return try ctx.fetch(req)
    }

    func deleteHabit(_ habit: Habit, ctx: NSManagedObjectContext) throws {
        try ctx.performAndWait {
            ctx.delete(habit) // rely on Cascade rules
            try ctx.save()
            log.info("Deleted habit and cascades")
        }
    }

    private func deactivateAll(ctx: NSManagedObjectContext) throws {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "isActive == true")
        let actives = try ctx.fetch(req)
        actives.forEach { $0.isActive = false }
    }
}
