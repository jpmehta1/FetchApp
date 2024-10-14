//
//  DetailView.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import SwiftUI

//each list id's items are listed here
struct DetailView: View {
    var items: [FetchData]
    var listID: Int

    var body: some View {
        List(items, id: \.id) { item in
            Text(item.name ?? "No name")
        }
        .navigationTitle("List ID \(listID)")
    }
}
