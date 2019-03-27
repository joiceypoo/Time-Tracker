//
//  DateCollectionViewCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 30/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    var date: Date!
    @IBOutlet weak var dayOfMonthLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            dayOfWeekLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
            dayOfMonthLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }
}
