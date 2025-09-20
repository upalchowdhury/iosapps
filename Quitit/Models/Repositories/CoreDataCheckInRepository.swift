import CoreData
import Foundation

final class CoreDataCheckInRepository: CheckInRepository {
    @discardableResult
    func createCheckIn(for habit: Habit,
                      date: Date,
                      isSuccessful: Bool,
                      photoPath: String?,
                      journalEntry: String?,
                      moodRating: Int,
                      ctx: NSManagedObjectContext) throws -> CheckIn {
        let checkIn = CheckIn(context: ctx)
        checkIn.id = UUID()
        checkIn.date = date
        checkIn.isSuccessful = isSuccessful
        checkIn.photoPath = photoPath
        checkIn.journalEntry = journalEntry
        checkIn.moodRating = Int16(moodRating)
        checkIn.habit = habit
        
        try ctx.save()
        return checkIn
    }
    
    func todayCheckIn(for habit: Habit, ctx: NSManagedObjectContext) throws -> CheckIn? {
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        
        let req: NSFetchRequest<CheckIn> = CheckIn.fetchRequest()
        req.predicate = NSPredicate(format: "habit == %@ AND date >= %@ AND date < %@",
                                    habit, start as NSDate, end as NSDate)
        req.fetchLimit = 1
        req.sortDescriptors = [NSSortDescriptor(keyPath: \CheckIn.date, ascending: false)]
        
        return try ctx.fetch(req).first
    }
}
