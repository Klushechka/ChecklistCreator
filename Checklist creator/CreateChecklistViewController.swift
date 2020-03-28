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

    var collectionView: UICollectionView?

    private let reuseIdentifier = "cell"
    
    private var viewModel: CreateChecklistViewModel? = nil

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
        guard let viewModel = self.viewModel, let cells = self.collectionView?.visibleCells else { return }

        let activeIconCell = cells.filter {$0.isSelected}.first

        guard let selectedIconCell = activeIconCell else { return }

        let iconIndexPath = self.collectionView?.indexPath(for: selectedIconCell)
        let selectedIcon = ChecklistIcon(rawValue: iconIndexPath?.row ?? ChecklistIcon.universal.raw)?.name ?? ChecklistIcon.universal.name

        viewModel.createNewChecklist(name: self.checklistTitleTextField.text ?? "", motivationText: self.motivationTextField.text ?? "", icon: selectedIcon)
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

extension CreateChecklistViewController: UICollectionViewDelegate, UICollectionViewDataSource
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChecklistIcon.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.collectionView = collectionView

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? IconSelectionCell

        if let imageName = ChecklistIcon(rawValue: indexPath.row)?.name {
            let iconImage = UIImage(named: imageName)

            cell?.icon.image = iconImage
        }

        if indexPath.row == ChecklistIcon.universal.raw {
            cell?.isHighlighted = true
        }

        return cell ?? UICollectionViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        highlightSelectedCell(with: indexPath)
    }

}

extension CreateChecklistViewController {

    func highlightSelectedCell(with indexPath: IndexPath) {
        let visibleCells = self.collectionView?.visibleCells

        guard let cells = visibleCells else { return }

        for cell in cells {
            cell.isHighlighted = self.collectionView?.indexPath(for: cell) == indexPath && cell.isSelected
        }
    }

}
