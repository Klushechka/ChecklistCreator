//
//  ChecklistIconCell.swift
//  Checklist creator
//
//  Created by Olga Klyushkina on 28.03.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation
import UIKit

final class ChecklistIconCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var numberOfDayLabel: UILabel!

    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.layer.borderWidth = 2.0
                self.layer.cornerRadius = 5.0
                self.layer.borderColor =
                    UIColor.green.withAlphaComponent(0.5).cgColor
            } else {
                self.layer.borderWidth = 0.0
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

}
