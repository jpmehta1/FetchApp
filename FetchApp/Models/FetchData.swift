//
//  FetchData.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//
import Foundation

struct FetchData: Codable {
    let id, listID: Int
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case listID = "listId"
        case name
    }
}

