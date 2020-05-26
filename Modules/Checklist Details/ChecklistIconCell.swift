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
    @IBOutlet weak var checkmarkImage: UIImageView!

    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted && oldValue != self.isHighlighted {
                self.checkmarkImage.image = UIImage(named: "checkmark.png")
            } else {
                self.checkmarkImage.image = nil
            }
        }
    }

}
