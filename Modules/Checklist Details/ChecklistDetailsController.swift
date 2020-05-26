//
//  ChecklistDetailsController.swift
//  Checklist creator
//
//  Created by Olga Klyushkina on 22.03.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation

final class ChecklistDetailsController: ChecklistDetailsViewModel {

    var uuid: String?
    var checklist: Checklist?
    var checklistDataProvider: ChecklistDataProvider?

    init(uuid: String) {
        self.uuid = uuid
    }

    func requestChecklist() {
        self.checklistDataProvider = ChecklistDataProvider.shared
        self.checklist = self.checklistDataProvider?.checklist(uuid: self.uuid)
    }

    func updatChecklistCompletedDays(dayIndex: Int, action: ChecklistDayAction) {
        guard let checklist = self.checklist else { return }

        self.checklistDataProvider?.updateChecklist(uuid: checklist.uuid, dayIndex: dayIndex, action: action)
    }

}
