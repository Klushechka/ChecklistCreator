//
//  ChecklistDetailsViewController.swift
//  Checklist creator
//
//  Created by Ольга Клюшкина on 04/08/2019.
//  Copyright © 2019 klyushkina. All rights reserved.
//

import Foundation
import UIKit

protocol ChecklistDetailsViewModel {

    var checklist: Checklist { get set }

}

final class ChecklistDetailsViewController: UIViewController {

    @IBOutlet weak var checklistNameLabel: UILabel!
    @IBOutlet weak var motivationTextLabel: UILabel!

    var collectionView: UICollectionView?
    private let reuseIdentifier = "detailsCell"

    var viewModel: ChecklistDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLabels()
        setUpAppearance()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    private func setUpAppearance() {
        self.checklistNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        self.motivationTextLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        self.motivationTextLabel.textColor = .lightGray
    }

    private func setUpLabels() {
        self.checklistNameLabel.text = self.viewModel?.checklist.name
        self.motivationTextLabel.text = self.viewModel?.checklist.motivationText
    }

}

extension ChecklistDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.checklist.numberOfDays ?? 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.collectionView = collectionView

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? ChecklistIconCell

        let iconImage = UIImage(named: self.viewModel?.checklist.icon ?? ChecklistIcon.universal.name)
        cell?.iconImage.image = iconImage
        cell?.numberOfDayLabel.text = String(indexPath.row + 1)
//        cell?.sizeToFit()

        return cell ?? UICollectionViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isHighlighted = true
    }

}

extension ChecklistDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 7

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }



}
