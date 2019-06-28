//
//  File.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import Foundation

enum CellType: Int, CaseIterable {
    case title
    case contents
    case addList
    case doneTask
}

class Arrays {
    static let shared = Arrays()
    var title: [String] = []
    
    // FIXME: - 초기화?
}
