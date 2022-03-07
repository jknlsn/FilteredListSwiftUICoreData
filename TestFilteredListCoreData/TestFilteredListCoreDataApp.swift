//
//  TestFilteredListCoreDataApp.swift
//  TestFilteredListCoreData
//
//  Created by Jake Nelson on 7/3/2022.
//

import SwiftUI

@main
struct TestFilteredListCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
