//
//  UIViewController+extension.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public extension UIViewController {
    static func instantiate(from name: StoryboardName) -> Self? {
        let sb = UIStoryboard(name: name.rawValue,
                              bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "\(self)ID")
        
        return dynamicCast(vc,
                           as: self)
    }
}

private func dynamicCast<T>(_ object: Any,
                            as: T.Type) -> T? {
    return object as? T
}
