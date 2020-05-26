//
//  BordlessTextField.swift
//  Checklist creator
//
//  Created by Olga Kliushkina on 26.05.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation
import UIKit

final class BorderlessTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showBottomLine()
        decorateTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        showBottomLine()
        decorateTextField()
    }
    
    private func showBottomLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height - 1, width: self.bounds.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    private func decorateTextField() {
        self.font = UIFont.systemFont(ofSize: 17, weight: .light)
    }
    
}

