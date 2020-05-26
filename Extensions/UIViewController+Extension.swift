//
//  ViewController extension.swift
//  Checklist creator
//
//  Created by Olga Klyushkina on 22.03.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    static func instantiateFrom(storyboardName: String, identidier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identidier)

    }
}
