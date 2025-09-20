import CoreData
import Foundation

protocol HabitRepository {
    func activeHabit(ctx: NSManagedObjectContext) throws -> Habit?
    func createHabit(name: String, type: String, makeActive: Bool, ctx: NSManagedObjectContext) throws -> Habit
    func setActive(_ habit: Habit, ctx: NSManagedObjectContext) throws
    func allHabits(ctx: NSManagedObjectContext) throws -> [Habit]
    func deleteHabit(_ habit: Habit, ctx: NSManagedObjectContext) throws
}

protocol UrgeRepository {
    @discardableResult
    func logUrge(for habit: Habit,
                 intensity: Int,
                 state: UrgeState,
                 trigger: String?, technique: String?,
                 location: String?, duration: Int?,
                 note: String?, at date: Date,
                 ctx: NSManagedObjectContext) throws -> UrgeLog

    func todayStats(for habit: Habit, ctx: NSManagedObjectContext)
      throws -> (resisted: Int, total: Int, avgIntensity: Double)
    
    func allUrges(for habit: Habit, ctx: NSManagedObjectContext) throws -> [UrgeLog]
}

protocol CheckInRepository {
    @discardableResult
    func createCheckIn(for habit: Habit,
                      date: Date,
                      isSuccessful: Bool,
                      photoPath: String?,
                      journalEntry: String?,
                      moodRating: Int,
                      ctx: NSManagedObjectContext) throws -> CheckIn
    
    func todayCheckIn(for habit: Habit, ctx: NSManagedObjectContext) throws -> CheckIn?
}
