//
//  Checklist.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 01/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum ChecklistIcon: Int {
    case coffee = 0
    case muffin
    case sigarette
    case universal
}

class Checklist: Object {
    
    @objc dynamic var numberOfDays: NSNumber? = 0
    @objc dynamic var name: String?
    @objc dynamic var motivationText: String?
    @objc dynamic var icon: ChecklistIcon = .universal
    
    convenience required init(numberOfDays: Int?, name: String?, motivationText: String?, icon: ChecklistIcon) {
        self.init()
        
        self.numberOfDays = numberOfDays as NSNumber?
        self.name = name
        self.motivationText = motivationText
        self.icon = icon
    }
    
}
