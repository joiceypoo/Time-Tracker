//
//  DateCollectionViewDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.

import UIKit

extension TodoItemsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (dateCollectionView.bounds.width - 56)/7,
                      height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else { return }

        if let currentIndexPath = currentIndexPath, currentIndexPath != indexPath {
            selectedCellIndexPath.append(indexPath)
            cell.contentView.backgroundColor = UIColor.customBlue
            cell.dayOfMonthLabel.textColor = .white
            cell.dayOfWeekLabel.textColor = .white
            displayDate(date: cell.date)
            fetchTodos(from: displayedDayOfWeek!)
            todoListsTable.reloadData()
        } else if let currentIndexPath = currentIndexPath, currentIndexPath == indexPath {
            displayDate(date: cell.date)
            fetchTodos(from: displayedDayOfWeek!)
            todoListsTable.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCellIndexPath.removeAll()
        let cell = collectionView.cellForItem(at: indexPath)
        if let myCell = cell as? DateCollectionViewCell, let currentIndexPath = currentIndexPath, currentIndexPath != indexPath {
            myCell.contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
            myCell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            myCell.dayOfWeekLabel.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        }
    }
}
