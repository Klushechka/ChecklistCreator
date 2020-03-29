//
//  ChecklistDataProvider.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 28/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import RealmSwift

enum ChecklistDayAction: Int {
    case add, remove
}

final class ChecklistDataProvider {
    
    static let shared = ChecklistDataProvider()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func saveChecklist(checklist: Checklist?) {
        guard let checklist = checklist else { return }
        
        try? self.realm.write {
            self.realm.add(checklist)
        }
    }
    
    func getChecklists() -> [Checklist] {
        let checklists = self.realm.objects(Checklist.self).sorted(byKeyPath: "timestamp", ascending: true)
        return checklists.map { $0 }
    }
    
    func deleteChecklist(with index: Int) {
        let checklists = getChecklists()
        
        try? self.realm.write {
            self.realm.delete(checklists[index])
        }
    }

    func checklist(uuid: String?) -> Checklist? {
        guard let uuid = uuid else { return nil }

        let realm = try! Realm()

        return realm.objects(Checklist.self).filter("uuid = %@", uuid).first
    }

    func updateChecklist(uuid: String, dayIndex: Int, action: ChecklistDayAction) {
        let realm = try! Realm()

        try! realm.write {
            let checklists = realm.objects(Checklist.self).filter("uuid = %@", uuid)
            guard let checklist = checklists.first else { return }

            let completedDaysIndices = checklist.completedDaysIndices
            switch action {
            case .add: completedDaysIndices.append(dayIndex)
            case .remove:
                if completedDaysIndices.contains(dayIndex), let indexOfDay = completedDaysIndices.index(of: dayIndex) {
                    completedDaysIndices.remove(at: indexOfDay)
                }
            }

            checklist.completedDaysIndices = completedDaysIndices
            realm.add(checklist)
        }
    }
    
}
