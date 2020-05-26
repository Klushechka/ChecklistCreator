//
//  PlaceholderView.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 26/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import UIKit
import Foundation

final class PlaceholderView: UIView, NibLoadable {
    
    @IBOutlet var placeholderDescriptionLabel: UILabel!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var createChecklistButton: UIButton!
    
    var addChecklistTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholderDescriptionLabel.text = "You have no checklists yet. Let's add the first one?"
        self.placeholderDescriptionLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        self.createChecklistButton.setTitle("Add a checklist", for: .normal)
        self.createChecklistButton.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        
        self.placeholderImageView.image = UIImage(named: "emptyListPlaceholder")
    }
    
    @IBAction func addChecklistButtonTapped(_ sender: UIButton) {
        addChecklistTapped?()
    }
    
}
