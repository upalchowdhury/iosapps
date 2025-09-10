//
//  QuititApp.swift
//  Quitit
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

@main
struct QuititApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
