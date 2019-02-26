//
//  CustomCollectionViewFlowLayout.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare () {
        super.prepare()
        
        var contentByItems: ldiv_t
        
        let contentSize = self.collectionViewContentSize
        let itemSize = self.itemSize
        
        if UICollectionView.ScrollDirection.vertical == self.scrollDirection {
            contentByItems = ldiv (Int(contentSize.height), Int(itemSize.height))
        } else {
            contentByItems = ldiv (Int(contentSize.height), Int(itemSize.height))
        }
        
        let layoutSpacingValue = CGFloat(NSInteger (CGFloat(contentByItems.rem))) / CGFloat (contentByItems.quot + 1)
        
        let originalMinimumLineSpacing = self.minimumLineSpacing
        let originalMinimumInteritemSpacing = self.minimumInteritemSpacing
        let originalSectionInset = self.sectionInset
        
        if layoutSpacingValue != originalMinimumLineSpacing ||
            layoutSpacingValue != originalMinimumInteritemSpacing ||
            layoutSpacingValue != originalSectionInset.left ||
            layoutSpacingValue != originalSectionInset.right ||
            layoutSpacingValue != originalSectionInset.top ||
            layoutSpacingValue != originalSectionInset.bottom {
            
            let insetsForItem = UIEdgeInsets.init(top: layoutSpacingValue, left: layoutSpacingValue, bottom: layoutSpacingValue, right: layoutSpacingValue)
            
            self.minimumLineSpacing = layoutSpacingValue
            self.minimumInteritemSpacing = layoutSpacingValue
            self.sectionInset = insetsForItem
        }
    }
}

