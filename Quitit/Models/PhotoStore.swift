import Foundation

struct PhotoStore {
    static func saveJPEG(_ data: Data, filename: String) throws -> String {
        let dir = FileManager.default
           .containerURL(forSecurityApplicationGroupIdentifier: PersistenceController.appGroupID)?
           .appendingPathComponent("Photos", isDirectory: true)
        
        guard let dir = dir else {
            throw PhotoStoreError.appGroupNotAvailable
        }
        
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(filename)
        try data.write(to: url, options: .completeFileProtectionUntilFirstUserAuthentication)
        return "Photos/\(filename)" // relative path to persist in Core Data
    }

    static func loadURL(_ relativePath: String) -> URL? {
        FileManager.default
          .containerURL(forSecurityApplicationGroupIdentifier: PersistenceController.appGroupID)?
          .appendingPathComponent(relativePath)
    }

    static func deleteAllPhotos() throws {
        let fm = FileManager.default
        if let dir = FileManager.default
              .containerURL(forSecurityApplicationGroupIdentifier: PersistenceController.appGroupID)?
              .appendingPathComponent("Photos", isDirectory: true) {
            if fm.fileExists(atPath: dir.path) { try fm.removeItem(at: dir) }
        }
    }
    
    static func generateFilename() -> String {
        return "\(UUID().uuidString).jpg"
    }
}

enum PhotoStoreError: Error {
    case appGroupNotAvailable
}
