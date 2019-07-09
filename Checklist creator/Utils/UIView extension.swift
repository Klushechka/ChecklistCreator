//
//  UIView extension.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 26/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    class func loadFromNib(name: String) -> UIView {
        return viewFromNib(nibName: name)
    }
    
    private class func viewFromNib(nibName: String) -> UIView {
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView else {
            fatalError("No nib was found for \(nibName)")
        }
        
        return view
    }
}
