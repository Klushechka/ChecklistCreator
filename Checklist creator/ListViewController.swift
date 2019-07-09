//
//  ListViewController.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 02/06/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

protocol ListViewModel {
    
    var numberOfItems: Int { get set }
    
}

final class ListViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var addChecklistButton: UIButton!
    
    var viewModel: ListViewModel? = nil
    var placeholderView: PlaceholderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func setup() {
        self.viewModel = ListModel()
        
        if self.viewModel?.numberOfItems == 0 {
            self.addChecklistButton.isHidden = true
            
            self.placeholderView = PlaceholderView.loadFromNib(name: "PlaceholderView") as? PlaceholderView
            
            guard let placeholderView = self.placeholderView else { return }
            self.viewContainer.addSubview(placeholderView)
            
            placeholderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func setCallbacks() {
        guard let placeholderView = self.placeholderView else { print ("Fail 1")
            return }
        
        placeholderView.addChecklistTapped = {
            
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateChecklistViewController", bundle: nil)
        let checklistViewController = storyboard.instantiateViewController(withIdentifier: "createChecklist") as? CreateChecklistViewController
            
            guard let checklistVC = checklistViewController else { return }
            
            self.present(checklistVC, animated: true, completion: nil)
        }
    }
    
}
