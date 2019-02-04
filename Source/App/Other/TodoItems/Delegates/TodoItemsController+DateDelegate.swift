//
//  DateCollectionViewDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.

import UIKit

extension TodoItemsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dateCollectionView.bounds.width/7, height: dateCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}