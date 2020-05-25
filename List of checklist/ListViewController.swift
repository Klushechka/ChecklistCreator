//
//  ListViewController.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 02/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

protocol ListViewModel {
    
    var numberOfItems: Int { get set }
    var numberOfChecklistsChanged: (() -> Void)? { get set }
    var isTableHidingNeeded: (() -> Void)? { get set }

    var checklists: [Checklist]? { get set }
    func getChecklists()
    func deleteChecklist(with index: Int)
    
}

final class ListViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var addChecklistButton: UIButton!
    
    var viewModel: ListViewModel? = nil
    var placeholderView: PlaceholderView?
    
    var checklistTableView: ChecklistTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialView()
        setUpdateTableViewCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        guard let viewModel = self.viewModel
            else { return }
        
        viewModel.getChecklists()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func setupInitialView() {
        self.viewModel = ListModel()
        
        if self.viewModel?.checklists?.count == 0 {
            showPlaceholder()
        }
        else {
            configureTableView()
        }
    }

    private func showPlaceholder() {
        self.addChecklistButton.isHidden = true

        if self.placeholderView == nil {
            self.placeholderView = PlaceholderView.loadFromNib(name: "PlaceholderView") as? PlaceholderView
        }

        guard let placeholderView = self.placeholderView else { return }

        self.viewContainer.addSubview(placeholderView)

        placeholderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setAddChecklistCallback()
    }

    func setUpdateTableViewCallback() {
        self.viewModel?.numberOfChecklistsChanged = {
            self.setDataToTableView()
        }
    }
    
    func setAddChecklistCallback() {
        guard let placeholderView = self.placeholderView else { print ("Fail 1")
            return }
        
        placeholderView.addChecklistTapped = {
            self.presentAddChecklistVC()
        }
    }
    
    func presentAddChecklistVC() {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateChecklistViewController", bundle: nil)
        let checklistViewController = storyboard.instantiateViewController(withIdentifier: "createChecklist") as? CreateChecklistViewController
        
        guard let checklistVC = checklistViewController else { return }

        checklistVC.checklistAdded = { [weak self] in
            self?.viewModel?.getChecklists()
        }

        self.present(checklistVC, animated: true, completion: nil)
    }
    
    @IBAction func addChecklistButtonTapped(_ sender: UIButton) {
        presentAddChecklistVC()
    }

}

extension ListViewController: UITableViewDelegate {
    
    private func configureTableView() {
        if self.checklistTableView == nil {
            self.checklistTableView = ChecklistTableView(frame: self.viewContainer.bounds)
        }
        
        guard let checklistTableView = self.checklistTableView else { return }
        guard !self.viewContainer.subviews.contains(checklistTableView) else {
            checklistTableView.removeFromSuperview()
            return
        }

        self.viewContainer.addSubview(checklistTableView)
        checklistTableView.isHidden = false
        checklistTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.placeholderView?.isHidden = true
        self.addChecklistButton.isHidden = false
        
        setDataToTableView()
        deleteChecklistCallback()
        tableHidingCallback()
        didSelectChecklistCallback()
    }
    
    private func setDataToTableView() {
         guard let viewModel = self.viewModel, let checklists = viewModel.checklists else {
            return
        }

        guard let checklistTableView = self.checklistTableView else {
            hidePlaceholderShowTable()

            return
        }

        if checklists.count > 0 && !self.viewContainer.contains(checklistTableView) {
            hidePlaceholderShowTable()
        }
        
        checklistTableView.checkilsts = checklists
    }
    
}

private extension ListViewController {

    func hideTableAndShowPlaceholder() {
        guard let checklistsTable = self.checklistTableView, self.viewContainer.subviews.contains(checklistsTable) else {
            return
        }

        checklistsTable.removeFromSuperview()
        showPlaceholder()
    }

    func hidePlaceholderShowTable() {
        self.placeholderView?.removeFromSuperview()
        configureTableView()
    }

}

private extension ListViewController {

    func showChecklistDeletionAlert(forCellWith index: Int) {
        let alert = UIAlertController(title: "Do you want to delete this checklist?", message: "You cannot undo this action.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {(action:UIAlertAction!) in
            self.deleteChecklist(with: index)
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func deleteChecklist(with index: Int) {
        guard let viewModel = self.viewModel else { return }

        viewModel.deleteChecklist(with: index)
    }

}

private extension ListViewController {

    func deleteChecklistCallback() {
        guard let checklistTableView = self.checklistTableView else { return }
        checklistTableView.checklistDeletiongInitiated = { index in
            self.showChecklistDeletionAlert(forCellWith: index)
        }
    }

    func tableHidingCallback() {
        self.viewModel?.isTableHidingNeeded = { [weak self] in
            self?.hideTableAndShowPlaceholder()
        }
    }

    func didSelectChecklistCallback() {
        self.checklistTableView?.checklistSelected = { [weak self] indexPathRow in
            guard let checklistDetailsVC = UIViewController.instantiateFrom(storyboardName: "ChecklistDetailsViewController", identidier: "checklistDetails") as? ChecklistDetailsViewController else { return }
            guard let checklist = self?.viewModel?.checklists?[indexPathRow] else { return }

            let detailsViewModel = ChecklistDetailsController(uuid: checklist.uuid)
            detailsViewModel.requestChecklist()
            checklistDetailsVC.viewModel = detailsViewModel
            self?.navigationController?.pushViewController(checklistDetailsVC, animated: true)
        }
    }

}

