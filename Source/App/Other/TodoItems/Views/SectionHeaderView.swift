//
//  IndentLabel.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 26/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class SectionHeaderView: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 20,
                                  left: 18,
                                  bottom: 4,
                                  right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
