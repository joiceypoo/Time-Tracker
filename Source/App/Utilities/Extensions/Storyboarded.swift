//
//  Storyboarded.swift
//  Atomic Habit Daily To Do Tracker
//
//  Created by Onyekachi Ezeoke on 09/04/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

/// A protocol that lets us instantiate view controllers from Main storyboard.
protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiate() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
