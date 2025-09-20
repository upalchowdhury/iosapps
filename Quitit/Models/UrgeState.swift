import Foundation

enum UrgeState: String, CaseIterable {
    case redirected = "redirected"  // Successfully resisted/redirected the urge
    case notYet = "notYet"         // Gave in to the urge
    case paused = "paused"         // Paused/delayed the urge
}
