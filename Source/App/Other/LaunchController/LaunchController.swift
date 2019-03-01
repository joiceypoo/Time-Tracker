//
//  LaunchController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 28/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class LaunchController: UIViewController {
    
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
        let scaledTransform = originalTransform.scaledBy(x: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.7, animations: {
            self.launchIcon.transform = scaledTransform
        }) { _ in
            self.navigate()
        }
    }
}
