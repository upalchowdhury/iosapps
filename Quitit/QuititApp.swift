//
//  QuitItApp.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

@main
struct QuitItApp: App {
    let persistenceController = PersistenceController.shared
    let userSettings = UserSettings.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userSettings)
                .onAppear {
                    userSettings.launchCount += 1
                }
        }
    }
}
