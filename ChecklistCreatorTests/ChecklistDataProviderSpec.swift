//
//  ChecklistCreatorTests.swift
//  ChecklistCreatorTests
//
//  Created by Olga Kliushkina on 20.05.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Nimble
import XCTest
import RealmSwift

@testable import ChecklistCreator

class ChecklistDataProviderSpec: XCTestCase {

    var checklistDataProvider: ChecklistDataProvider?
    var checklist: Checklist?
    
    override func setUp() {
        super.setUp()
        
        let uuid = UUID().uuidString
        let name = "Checklist Name"
        let iconName = "coffee"
        let motivationText = "You can do it!"
        let timeStamp = Date()
        
        self.checklist = Checklist(uuid: uuid, numberOfDays: 30, name: name, motivationText: motivationText, iconName: iconName, timestamp: timeStamp)
        
        self.checklistDataProvider = ChecklistDataProvider.shared
    }

    override func tearDown() {
        super.tearDown()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }

    func testSavingChecklist() {
        self.checklistDataProvider?.saveChecklist(checklist: self.checklist)
        
        expect(self.checklistDataProvider?.checklist(uuid: self.checklist?.uuid)).toNot(beNil())
        
    }
    
    func testDeletingChecklist() {
        self.checklistDataProvider?.saveChecklist(checklist: self.checklist)
        self.checklistDataProvider?.deleteChecklist(with: 0)
        
        expect(self.checklistDataProvider?.fetchChecklists().count).to(equal(0))
    }
    
    func testMarkChecklistDayCompleted() {
        self.checklistDataProvider?.saveChecklist(checklist: self.checklist)
        self.checklistDataProvider?.updateChecklist(uuid: self.checklist?.uuid, dayIndex: 5, action: .markAsCompleted)
        
        let updatedChecklist = self.checklistDataProvider?.checklist(uuid: self.checklist?.uuid)
        
        guard let completedDaysIndices = updatedChecklist?.completedDaysIndices else {
            fail("Completed days indices are nil")
            
            return
        }
        
        expect(completedDaysIndices.contains(5)).to(beTrue())
    }
    
    func testMarkChecklistDayIncompleted() {
        self.checklistDataProvider?.saveChecklist(checklist: self.checklist)
        self.checklistDataProvider?.updateChecklist(uuid: self.checklist?.uuid, dayIndex: 7, action: .markAsCompleted)
        self.checklistDataProvider?.updateChecklist(uuid: self.checklist?.uuid, dayIndex: 7, action: .markAsIncompleted)
        
        let updatedChecklist = self.checklistDataProvider?.checklist(uuid: self.checklist?.uuid)
        
        guard let completedDaysIndices = updatedChecklist?.completedDaysIndices else {
            fail("Completed days indices are nil")
            
            return
        }
        
        expect(completedDaysIndices.contains(5)).to(beFalse())
    }
    
    func testFetchingMultipleChecklists() {
        self.checklistDataProvider?.saveChecklist(checklist: self.checklist)
        
        let secondChecklist = Checklist(uuid: UUID().uuidString, numberOfDays: 31, name: "Another Checklist Name", motivationText: "Do it!", iconName: "coffee", timestamp: Date())
        self.checklistDataProvider?.saveChecklist(checklist: secondChecklist)
        
        guard let savedChecklists = self.checklistDataProvider?.fetchChecklists() else {
            fail("Received nil instead of saved checklists")
            
            return
        }
        
        expect(savedChecklists.count).to(equal(2))
        
    }

}
