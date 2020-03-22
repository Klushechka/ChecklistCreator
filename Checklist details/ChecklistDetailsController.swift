//
//  ChecklistDetailsController.swift
//  Checklist creator
//
//  Created by Olga Klyushkina on 22.03.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation

final class ChecklistDetailsController: ChecklistDetailsViewModel {

    var checklist: Checklist

    init(checklist: Checklist) {
        self.checklist = checklist
    }

}
