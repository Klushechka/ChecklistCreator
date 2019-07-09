//
//  Checklist.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 01/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation

enum ChecklistIcon {
    case coffee
    case muffin
    case sigarette
}

final class Checklist {
    
    var numberOfDays: Int
    var name: String
    var motivationText: String?
    var icon: ChecklistIcon
    
    init(numberOfDays: Int, name: String, motivationText: String?, icon: ChecklistIcon) {
        self.numberOfDays = numberOfDays
        self.name = name
        self.motivationText = motivationText
        self.icon = icon
    }
    
}
