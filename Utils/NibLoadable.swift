//
//  NibLoadable.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 26/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static var nib: UINib { get }
}

extension NibLoadable {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
