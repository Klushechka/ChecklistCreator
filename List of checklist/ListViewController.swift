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
        
        setup()
        setCallbacks()
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
    
    
    private func setup() {
        self.viewModel = ListModel()
        
        if self.viewModel?.checklists?.count == 0 {
            self.addChecklistButton.isHidden = true
            
            self.placeholderView = PlaceholderView.loadFromNib(name: "PlaceholderView") as? PlaceholderView
            
            guard let placeholderView = self.placeholderView else { return }
            self.viewContainer.addSubview(placeholderView)
            
            placeholderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        else {
            configureTableView()
        }
    }
    
    private func setCallbacks() {
        setAddChecklistCallback()
        setUpdateTableViewCallback()
        deleteChecklistCallback()
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
    
    func deleteChecklistCallback() {
        guard let checklistTableView = self.checklistTableView else { return }
        checklistTableView.checklistDeletiongInitiated = { index in
            self.showChecklistDeletionAlert(forCellWith: index)
        }
    }
    
    func presentAddChecklistVC() {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateChecklistViewController", bundle: nil)
        let checklistViewController = storyboard.instantiateViewController(withIdentifier: "createChecklist") as? CreateChecklistViewController
        
        guard let checklistVC = checklistViewController else { return }
        
        self.present(checklistVC, animated: true, completion: nil)
    }
    
    @IBAction func addChecklistButtonTapped(_ sender: UIButton) {
        presentAddChecklistVC()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func configureTableView() {
        self.checklistTableView = ChecklistTableView(frame: self.viewContainer.bounds)
        
        guard let checklistTableView = self.checklistTableView else { return }
        
        self.viewContainer.addSubview(checklistTableView)
        
        checklistTableView.isHidden = false
        self.placeholderView?.isHidden = true
        
        setDataToTableView()
    }
    
    private func setDataToTableView() {
         guard let viewModel = self.viewModel, let checklists = viewModel.checklists, let checklistTableView = self.checklistTableView else {
            return
        }
        
        checklistTableView.checkilsts = checklists
    }
    
    func showChecklistDeletionAlert(forCellWith index: Int) {
        let alert = UIAlertController(title: "Delete Checklist", message: "Are you sure you want to delete this checklist?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            
            self.deleteChecklist(with: index)
            
            print("Action")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteChecklist(with index: Int) {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.deleteChecklist(with: index)
    }
        
    
}

