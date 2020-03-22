//
//  ListModel.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 26/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation

final class ListModel: ListViewModel {
    
    var numberOfItems: Int = 0
    var numberOfChecklistsChanged: (() -> Void)?
    var isTableHidingNeeded: (() -> Void)?

    var checklists: [Checklist]? {
        didSet(oldValue) {
            if self.checklists != oldValue {
                if self.checklists?.count == 0 {
                    self.isTableHidingNeeded?()

                    return
                }

                self.numberOfChecklistsChanged?()
            }
        }
    }
    
    private let checklistDataProvider = ChecklistDataProvider.shared
    
    init() {
        getChecklists()
    }
    
    func getChecklists() {
        self.checklists = self.checklistDataProvider.getChecklists()
    }
    
    func deleteChecklist(with index: Int) {
        self.checklistDataProvider.deleteChecklist(with: index)
        getChecklists()
    }
}
