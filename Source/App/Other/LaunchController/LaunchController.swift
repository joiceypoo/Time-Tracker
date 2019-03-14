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
        guard let todoItemsController = TodoItemsController.instantiate(from: .main) else { return }
        
        let customNavigationController = UINavigationController(rootViewController: todoItemsController)
        present(customNavigationController, animated: true)
    }
    
    private func animateView() {
        let originalTransform = launchIcon.transform
        launchIcon.transform = .identity
        let scaledTransform = originalTransform.scaledBy(x: 4.2, y: 4.2)
        UIView.animate(withDuration: 0.9, delay: 0, options: .curveEaseOut, animations: {
            self.launchIcon.transform = scaledTransform
            self.view.layoutIfNeeded()
        }) { _ in
            self.navigate()
        }
    }
}
