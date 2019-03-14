//
//  UITableViewCell+Extension.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static func instantiate(from tableView: UITableView,
                            for indexPath: IndexPath) -> Self? {
        let cellID = "\(self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath)
        
        return dynamicCast(cell,
                           as: self)
    }
}

private func dynamicCast<T>(_ object: Any,
                            as: T.Type) -> T? {
    return object as? T
}
