//
//  Fruit.swift
//  Kadai16-Sako0602-SwiftUI
//
//  Created by sako0602 on 2023/01/28.
//

import Foundation

struct FruitsData: Codable, Identifiable {
    var id = UUID()
    var name: String
    var isChecked: Bool
}

