//
//  LaunchController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 28/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class LaunchController: UIViewController {
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var launchIcon: UIImageView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        animateView()
    }
    
    private func navigate() {
        let todoItemsController = TodoItemsController.instantiate()
        let customNavigationController = UINavigationController(rootViewController: todoItemsController)
        present(customNavigationController, animated: true)
    }
    
    private func animateView() {
        let originalTransform = launchIcon.transform
        let scaledTransform: CGAffineTransform?
        
        if UIDevice.current.screenType == .unknown {
            scaledTransform = originalTransform.scaledBy(x: 2.2, y: 2.2)
        } else if UIDevice.current.screenType == .iPhone_XR {
            scaledTransform = originalTransform.scaledBy(x: 3.5, y: 3.5)
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            scaledTransform = originalTransform.scaledBy(x: 5.2, y: 5.2)
        } else if UIDevice.current.screenType == .iPhone_XSMax {
            scaledTransform = originalTransform.scaledBy(x: 3.5, y: 3.5)
        } else {
            scaledTransform = originalTransform.scaledBy(x: 4.2, y: 4.2)
        }
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveLinear, animations: {
            if let scaledTransform = scaledTransform {
                self.launchIcon.transform = scaledTransform
            }
        }) { _ in
            self.navigate()
        }
    }
}
