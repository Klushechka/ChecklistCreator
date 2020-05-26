//
//  TitleLabel.swift
//  Checklist creator
//
//  Created by Olga Kliushkina on 26.05.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation
import UIKit

final class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        decorateLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        decorateLabel()
    }
    
    private func decorateLabel() {
        self.textColor = .darkGray
        self.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }
    
}
