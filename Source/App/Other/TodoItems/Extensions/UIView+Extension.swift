//
//  UIView+Extension.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 04/04/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension UIView {
    func animateButton() {
        self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.transform = .identity
        }, completion: nil)
    }
}
