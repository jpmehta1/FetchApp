//
//  HomeView.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import SwiftUI

struct HomeView: View {
    // this state object will hold the home view model
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        // The navigation view allows for navigation between views with a title, not needed here
        NavigationView {
            // Using a List to show data groups
            List {
                // loop through and sort the keys(listID's) which point to the array containing the items
                ForEach(viewModel.groupedAndSortedData.keys.sorted(), id: \.self) { listID in
                    // create a section for each list ID
                    Section(header: Text("List ID \(listID)")) {
                        // checks for nil using nil-coalescing
                        ForEach(viewModel.groupedAndSortedData[listID] ?? [], id: \.id) { item in
                            Text("\(item.name ?? "No name")")
                        }
                    }
                }
            }
            .navigationTitle("Items") // sets the title for the navigation bar
        }
    }
}

//#Preview {
//    HomeView()
//}
