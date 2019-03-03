//
//  DateCollectionViewDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9999
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        let addedDays = indexPath.row
        var addedDaysDateComp = DateComponents()
        addedDaysDateComp.day = addedDays
        let currentCellDate = Calendar.current.date(byAdding: addedDaysDateComp ,
                                                    to: UsedDates.shared.startDate)
        
        if let cellDate = currentCellDate {
            cell.date = cellDate
            let dayOfMonth = Calendar.current.component(.day, from: cellDate)
            cell.dayOfMonthLabel.text = String(describing: dayOfMonth)
            
            let dayOfWeek = Calendar.current.component(.weekday, from: cellDate)
            cell.dayOfWeekLabel.text = String(describing: UsedDates.shared.getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: dayOfWeek))
        }
        
        let order = Calendar.current.compare(cell.date, to: UsedDates.shared.currentDate, toGranularity: .day)
        if order == ComparisonResult.orderedSame {
            currentIndexPath = indexPath
            cell.dayOfWeekLabel.textColor = UIColor.customBlue
            cell.dayOfMonthLabel.textColor = UIColor.customBlue
        } else if let newIndexPath = currentIndexPath, newIndexPath == indexPath {
            cell.dayOfWeekLabel.textColor = UIColor.customBlue
            cell.dayOfMonthLabel.textColor = UIColor.customBlue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let currentIndexPath = currentIndexPath else { return }
        if !selectedCellIndexPath.isEmpty {
            let newIndexPath = selectedCellIndexPath[0]
            let cell = collectionView.cellForItem(at: newIndexPath) as? DateCollectionViewCell
            cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
            cell?.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            cell?.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        }
        else if let cell = cell as? DateCollectionViewCell, currentIndexPath != indexPath {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            cell.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        }
        
        if let cell = cell as? DateCollectionViewCell, currentIndexPath != indexPath {
            if cell.dayOfMonthLabel.textColor == UIColor.customBlue {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
                cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
                cell.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            }
        }
        
        if let cell = cell as? DateCollectionViewCell, cell.contentView.backgroundColor == .customBlue {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            cell.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        }
    
        feedbackGenerator?.selectionChanged()
    }
    
    
}
