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
    
    func createNewChecklist(name: String, motivationText: String?, icon: String) {
        let checklist = Checklist(uuid: NSUUID().uuidString, numberOfDays: 30, name: name, motivationText: motivationText, iconName: icon, timestamp: Date())
        
        let checklistDataProvider = ChecklistDataProvider.shared
        
        checklistDataProvider.saveChecklist(checklist: checklist)
    }
    
}
