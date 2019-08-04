//
//  ChecklistDetailsViewController.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 04/08/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import UIKit

final class ChecklistDetailsViewController: UIViewController {
    
    @IBOutlet weak var checklistNameLabel: UILabel!
    @IBOutlet weak var motivationTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checklistNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        self.motivationTextLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        self.motivationTextLabel.textColor = .lightGray
    }
}
