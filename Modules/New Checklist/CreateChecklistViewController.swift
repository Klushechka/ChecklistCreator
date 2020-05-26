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

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var checklistTitleLabel: TitleLabel!
    @IBOutlet weak var checklistTitleTextField: BorderlessTextField!
    
    @IBOutlet weak var motivationTextLabel: TitleLabel!
    @IBOutlet weak var motivationTextField: BorderlessTextField!
    
    @IBOutlet weak var chooseIconLabel: TitleLabel!
    @IBOutlet weak var dayToStartTextLabel: TitleLabel!

    private var collectionView: UICollectionView?
    private var weekdayPicker: UIPickerView?

    private let reuseIdentifier = "cell"
    
    private var viewModel: CreateChecklistViewModel? = nil

    var checklistAdded: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CreateChecklistModel()
        
        configureUI()
        setPickerView()
        
        monitorTextEditing()
        becomeTextFieldsDelegate()
    }
    
    private func configureUI() {
        self.navbarTitle.title = "New Checklist"
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.doneButton.isEnabled = false
        
        self.checklistTitleLabel.text = "CHECKLIST TITLE"
        self.checklistTitleTextField.placeholder = "For example, \"30 days without coffee\""

        self.motivationTextLabel.text = "MOTIVATION TEXT"
        self.motivationTextField.placeholder = "For example, \"You can do it!\""
        
        self.chooseIconLabel.text = "CHECKLIST ICON"
        self.dayToStartTextLabel.text = "DAY TO START"
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let viewModel = self.viewModel, let cells = self.collectionView?.visibleCells, let checklistTitleText =  self.checklistTitleTextField.text else { return }

        let activeIconCell = cells.filter { $0.isSelected }.first

        guard let selectedIconCell = activeIconCell else { return }

        let iconIndexPath = self.collectionView?.indexPath(for: selectedIconCell)
        let selectedIcon = ChecklistIcon(rawValue: iconIndexPath?.row ?? ChecklistIcon.universal.raw)?.name ?? ChecklistIcon.universal.name

        viewModel.createNewChecklist(name: checklistTitleText, motivationText: self.motivationTextField.text ?? "", icon: selectedIcon)
        self.dismiss(animated: true, completion: nil)
        self.checklistAdded?()
    }
}

private extension CreateChecklistViewController {

    func monitorTextEditing() {
        self.checklistTitleTextField.addTarget(self, action: #selector(enableDoneButton), for: UIControl.Event.editingChanged)
    }

    @objc func enableDoneButton() {
        guard let checklistTitleText = self.checklistTitleTextField.text else { return }

        self.doneButton.isEnabled = !checklistTitleText.isEmpty
    }
    
}

extension CreateChecklistViewController: UITextFieldDelegate {
    
    func becomeTextFieldsDelegate() {
        self.checklistTitleTextField.delegate = self
        self.motivationTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.checklistTitleTextField {
            self.motivationTextField.becomeFirstResponder()
        }
        else if textField == self.motivationTextField {
            self.motivationTextField.resignFirstResponder()
        }
        
        return true
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
            cell?.isSelected = true
        }

        return cell ?? UICollectionViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension CreateChecklistViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func setPickerView() {
        self.weekdayPicker = UIPickerView()

        guard let weekdayPicker = self.weekdayPicker else { return }
        self.containerView.addSubview(weekdayPicker)

        weekdayPicker.snp.makeConstraints { make in
            make.top.equalTo(self.dayToStartTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.dayToStartTextLabel.snp.leading)
             make.trailing.equalTo(self.dayToStartTextLabel.snp.trailing)
        }

        weekdayPicker.delegate = self
        weekdayPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return DateFormatter.shortWeekdayNames.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DateFormatter.shortWeekdayNames[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print ("I've selected the first day of checklist:\(DateFormatter.shortWeekdayNames[row])")

        self.view.endEditing(true)
    }
    
}
