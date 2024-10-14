//
//  HomeView.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import SwiftUI

struct HomeView: View {
    //msin view model
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.groupedAndSortedData.keys.sorted(), id: \.self) { listID in
                    Section(header: Text("List ID \(listID)")) {
                        // Navigation link to navigate to the detail view of each List ID
                        NavigationLink(destination: DetailView(items: viewModel.groupedAndSortedData[listID] ?? [], listID: listID)) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .foregroundColor(.blue)
                                Text("List ID \(listID)")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Items")
        }
    }
}

