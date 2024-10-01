//
//  quotesApp.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import SwiftUI

@main
struct quotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
