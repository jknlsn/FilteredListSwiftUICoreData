//
//  ContentView.swift
//  TestFilteredListCoreData
//
//  Created by Jake Nelson on 7/3/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Favourites")){
                    ForEach(items.filter{$0.favorite}) { item in
                        Text(item.timestamp!, formatter: itemFormatter)
                        .swipeActions(edge: .leading) {
                            Button {
                                item.favorite.toggle()
                                PersistenceController.shared.save()
                            } label: {
                                Label(item.favorite ? "Unfavourite" : "Favourite", systemImage: item.favorite ? "star.slash" : "star")
                            }
                            .tint(.yellow)
                        }
                    }
                }
                
                Section(header: Text("Not favourites")){
                    ForEach(items.filter{!$0.favorite}) { item in
                        Text(item.timestamp!, formatter: itemFormatter)
                        .swipeActions(edge: .leading) {
                            Button {
                                item.favorite.toggle()
                                PersistenceController.shared.save()
                            } label: {
                                Label(item.favorite ? "Unfavourite" : "Favourite", systemImage: item.favorite ? "star.slash" : "star")
                            }
                            .tint(.yellow)
                        }
                    }
                }
            }
            .navigationBarTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
