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

    var uuid: String? { get set }
    var checklist: Checklist? { get set }

    func updatChecklistCompletedDays(dayIndex: Int, action: ChecklistDayAction)

}

final class ChecklistDetailsViewController: UIViewController {

    @IBOutlet weak var motivationTextLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var weekdaysCollectionView: UICollectionView!

    private let detailsCellReuseIdentifier = "detailsCell"
    private let weekdayCellReuseIdentifier = "weekdayCell"

    var viewModel: ChecklistDetailsViewModel?

    var checklistTitleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLabels()
        configureNavBarTitle()
        setUpAppearance()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.daysCollectionView.collectionViewLayout.invalidateLayout()
        self.weekdaysCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func setUpAppearance() {
        self.motivationTextLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        self.motivationTextLabel.textColor = .lightGray
    }

    private func setUpLabels() {
        self.motivationTextLabel.text = self.viewModel?.checklist?.motivationText
    }

    private func configureNavBarTitle() {
        let checklistLabel = UILabel()

        checklistLabel.lineBreakMode = .byTruncatingTail
        checklistLabel.translatesAutoresizingMaskIntoConstraints = false
        checklistLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        checklistLabel.textAlignment = .center

        navigationItem.titleView = checklistLabel

        checklistLabel.text = self.viewModel?.checklist?.name
    }

}

extension ChecklistDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.daysCollectionView {
            return self.viewModel?.checklist?.numberOfDays ?? 30
        }
        if collectionView == self.weekdaysCollectionView {
            return DateFormatter.shortWeekdayNames.count
        }

        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.daysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.detailsCellReuseIdentifier, for: indexPath) as? ChecklistIconCell

            let iconImage = UIImage(named: self.viewModel?.checklist?.icon ?? ChecklistIcon.universal.name)
            cell?.iconImage.image = iconImage
            cell?.numberOfDayLabel.text = String(indexPath.row + 1)

            if let dayIsCompleted = self.viewModel?.checklist?.completedDaysIndices.contains(indexPath.row), dayIsCompleted {
                cell?.isHighlighted = true
            }

            return cell ?? UICollectionViewCell()
        }

        if collectionView == self.weekdaysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.weekdayCellReuseIdentifier, for: indexPath) as? WeekdayCell
            cell?.weekdayTextLabel.text = DateFormatter.shortWeekdayNames[indexPath.row]
            cell?.weekdayTextLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            cell?.isUserInteractionEnabled = false

            return cell ?? UICollectionViewCell()
        }

        return UICollectionViewCell()
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.daysCollectionView {
            print("You selected cell #\(indexPath.item)!")
            let cell = collectionView.cellForItem(at: indexPath)
            
            guard let isDayCompleted = (self.viewModel?.checklist?.completedDaysIndices.contains(indexPath.row))  else { return }
            
            cell?.isHighlighted = !isDayCompleted
            let action: ChecklistDayAction = isDayCompleted ? .markAsIncompleted : .markAsCompleted
            
            self.viewModel?.updatChecklistCompletedDays(dayIndex: indexPath.row, action: action)
        }
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
