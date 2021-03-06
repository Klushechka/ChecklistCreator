//
//  ChecklistTableViewCell.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 31/07/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell, NibLoadable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checklistIconImage: UIImageView!
    @IBOutlet weak var motivationTextLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.motivationTextLabel.textColor = .lightGray
    }
    
}
