//
//  Checklist.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 01/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import RealmSwift

class IntObject: Object {
    dynamic var value = 0
}

enum ChecklistIcon: Int, CaseIterable {
    case coffee = 0
    case muffin
    case sigarette
    case universal

    var name: String {
        switch self {
        case .coffee: return "coffee.png"
        case .muffin: return "muffin.png"
        case .sigarette: return "sigarette.png"
        case .universal: return "universal.png"
        }
    }

    var raw: Int {
        return self.rawValue
    }
}

class Checklist: Object {

    @objc dynamic var uuid: String = ""
    @objc dynamic var numberOfDays: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var motivationText: String = ""
    @objc dynamic var icon: String = "task"
    @objc dynamic var timestamp: Date?
    var completedDaysIndices: List<Int> = List<Int>()

    convenience init(uuid: String, numberOfDays: Int?, name: String?, motivationText: String?, iconName: String, timestamp: Date, completedDaysIndices: List<Int> = List<Int>()) {
        self.init()

        self.uuid = uuid
        self.numberOfDays = numberOfDays ?? 0
        self.name = name ?? ""
        self.motivationText = motivationText ?? ""
        self.icon = iconName
        self.timestamp = timestamp
        self.completedDaysIndices = completedDaysIndices
    }

}
