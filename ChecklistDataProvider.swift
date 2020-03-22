//
//  ChecklistDataProvider.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 28/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import RealmSwift

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
    
}
