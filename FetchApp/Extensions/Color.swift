//
//  Color.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import Foundation
import SwiftUI

extension Color{
    static let theme = ColorTheme()
}

struct ColorTheme{
    let primaryTextColor = Color("ForText")
    let itemBackgroundColor = Color("BackgroundColor")
}
