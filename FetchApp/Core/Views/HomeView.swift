//
//  HomeView.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import SwiftUI

struct HomeView: View {
    // This state object will hold our view model, which fetches and processes the data
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        // The navigation view allows for navigation between views with a title
        NavigationView {
            // Using a List to present data groups
            List {
                // Loop through the keys (list IDs) which are sorted for display
                ForEach(viewModel.groupedAndSortedData.keys.sorted(), id: \.self) { listID in
                    // Create a section for each list ID
                    Section(header: Text("List ID \(listID)")) {
                        // Check for nil using nil-coalescing to provide an empty array if nil
                        ForEach(viewModel.groupedAndSortedData[listID] ?? [], id: \.id) { item in
                            Text("\(item.name ?? "No name")")
                        }
                    }
                }
            }
            .navigationTitle("Items") // Set the title for the navigation bar
        }
    }
}

//#Preview {
//    HomeView()
//}
