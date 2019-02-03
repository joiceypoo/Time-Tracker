//
//  IndentLabel.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 26/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class IndentLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0,
                                  left: 18,
                                  bottom: 0,
                                  right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
