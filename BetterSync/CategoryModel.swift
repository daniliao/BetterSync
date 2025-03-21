//
//  CategoryModel.swift
//  BetterSync
//
//  Created by Linda Chen on 3/20/25.
//

import Foundation
import SwiftUI

struct CategoryGroup: Identifiable{
    var id = UUID()
    var groupName: String
    var categories: [String]
    
}
