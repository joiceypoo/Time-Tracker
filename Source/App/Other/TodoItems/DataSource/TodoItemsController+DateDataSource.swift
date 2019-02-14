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
            cell.dayOfMonth.text = String(describing: dayOfMonth)
        }
        return cell
    }
    
    
}
