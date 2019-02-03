//
//  CustomTitleCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .customBlack
    }
}
