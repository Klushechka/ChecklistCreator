//
//  ChecklistTableView.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 31/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class ChecklistTableView: UIView, UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib.init(nibName: "ChecklistTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChecklistTableViewCell")
        
        return tableView
    }()

    var checkilsts = [Checklist]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var checklistDeletiongInitiated: ((Int) -> Void)?
    var checklistSelected: ((Int) -> Void)?
    
    @objc public override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        configureTable()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTable() {
        self.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableViewCell(dequeueReusableCellWithIdentifier identifier: String) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(withIdentifier: identifier)!
    }
    
}

extension ChecklistTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkilsts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChecklistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChecklistTableViewCell", for: indexPath) as! ChecklistTableViewCell
        
        if self.checkilsts.count != 0 {
            cell.nameLabel.text = self.checkilsts[indexPath.row].name
            cell.motivationTextLabel.text = self.checkilsts[indexPath.row].motivationText

            let image = UIImage(named: self.checkilsts[indexPath.row].icon)
            cell.checklistIconImage.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checklistSelected?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.checklistDeletiongInitiated?(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
