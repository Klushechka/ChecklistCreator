//
//  CreateChecklistViewController.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 02/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import UIKit

protocol CreateChecklistViewModel {
    
    func createNewChecklist(name: String, motivationText: String?, icon: String)
    
}

final class CreateChecklistViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var checklistTitleLabel: UILabel!
    @IBOutlet weak var checklistTitleTextField: UITextField!
    @IBOutlet weak var motivationTextLabel: UILabel!
    @IBOutlet weak var motivationTextField: UITextField!
    @IBOutlet weak var chooseIconLabel: UILabel!
    
    var viewModel: CreateChecklistViewModel? = nil
    var checklistAdded: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateChecklistModel()
        
        configureUI()
        monitorTextEditing()
    }
    
    private func configureUI() {
        self.navbarTitle.title = "New Checklist"
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.doneButton.isEnabled = false
        
        self.checklistTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.checklistTitleLabel.text = "Checklist Title:"
        self.checklistTitleTextField.placeholder = "For example, \"30 days without coffee\""
        self.checklistTitleTextField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        
        self.motivationTextLabel.text = "Motivation text:"
        self.motivationTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        self.motivationTextField.placeholder = "For example, \"You can do it!\""
        self.motivationTextField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        self.chooseIconLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.chooseIconLabel.text = "Choose an icon for your checklist:"
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.createNewChecklist(name: self.checklistTitleTextField.text ?? "", motivationText: self.motivationTextField.text ?? "", icon: "task")
        self.dismiss(animated: true, completion: nil)
        self.checklistAdded?()
    }
}

extension CreateChecklistViewController {

    private func monitorTextEditing() {
        self.checklistTitleTextField.addTarget(self, action: #selector(enableDoneButton), for: UIControl.Event.editingChanged)
    }

    @objc private func enableDoneButton() {
        guard let checklistTitleText = self.checklistTitleTextField.text else { return }

        self.doneButton.isEnabled = !checklistTitleText.isEmpty
    }
}
