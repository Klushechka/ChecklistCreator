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
        
        let checklistDataProvider = ChecklistDataProvider.shared
        
        checklistDataProvider.saveChecklist(checklist: checklist)
        
        print (Realm.Configuration.defaultConfiguration.fileURL as Any)
        
    }
    
}
