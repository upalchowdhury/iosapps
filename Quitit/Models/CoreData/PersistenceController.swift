//
//  PersistenceController.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import CoreData
import Foundation

enum SyncMode { case localOnly, iCloud }

final class PersistenceController {
    static let appGroupID = "group.com.quitit"
    static let modelName  = "Quitit"
    static let shared     = PersistenceController()

    let container: NSPersistentContainer

    init(syncMode: SyncMode = .iCloud) {
        let storeURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupID)?
            .appendingPathComponent("\(Self.modelName).sqlite")

        func configure(_ desc: NSPersistentStoreDescription) {
            if let storeURL = storeURL {
                desc.url = storeURL
            }
            desc.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            desc.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            desc.setOption(FileProtectionType.completeUntilFirstUserAuthentication as NSObject,
                           forKey: NSPersistentStoreFileProtectionKey)
        }

        if syncMode == .iCloud {
            let c = NSPersistentCloudKitContainer(name: Self.modelName)
            if let d = c.persistentStoreDescriptions.first { configure(d) }
            c.loadPersistentStores { _, error in if let error { fatalError("CoreData: \(error)") } }
            c.viewContext.automaticallyMergesChangesFromParent = true
            c.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container = c
        } else {
            let c = NSPersistentContainer(name: Self.modelName)
            if let d = c.persistentStoreDescriptions.first { configure(d) }
            c.loadPersistentStores { _, error in if let error { fatalError("CoreData: \(error)") } }
            c.viewContext.automaticallyMergesChangesFromParent = true
            c.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container = c
        }
    }

    func saveContext() {
        let ctx = container.viewContext
        guard ctx.hasChanges else { return }
        do { try ctx.save() } catch { assertionFailure("Save failed: \(error)") }
    }

    // In-memory store for Previews
    static func preview() -> PersistenceController {
        let pc = PersistenceController(syncMode: .localOnly)
        let d = NSPersistentStoreDescription()
        d.type = NSInMemoryStoreType
        pc.container.persistentStoreDescriptions = [d]
        pc.container.loadPersistentStores(completionHandler: { _, _ in })
        
        // Clean preview context - no sample data
        return pc
    }
}
