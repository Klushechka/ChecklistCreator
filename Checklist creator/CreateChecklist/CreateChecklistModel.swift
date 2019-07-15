//
//  CreateChecklistModel.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 02/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import RealmSwift

final class CreateChecklistModel: CreateChecklistViewModel {
    
    func createNewChecklist(name: String, motivationText: String?, icon: ChecklistIcon) {
        let checklist = Checklist(numberOfDays: 30, name: name, motivationText: motivationText, icon: icon)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(checklist)
        }
        
        print (Realm.Configuration.defaultConfiguration.fileURL)
        print ("New checklist is \(checklist.name) \(checklist.motivationText)")
        
    }
    
}
