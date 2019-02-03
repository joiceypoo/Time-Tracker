//
//  AddCategoryController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import CoreData

protocol AddCategoryDelegate {
    func didAddCategory(category: Category)
}

class AddCategoryController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    var delegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Category"
        view.backgroundColor = .customDarkBlack
        navigationController?.navigationBar.prefersLargeTitles = false
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                style: .plain,
                                                target: self,
                                                action: #selector(handleViewDismiss))
        leftBarButtonItem.tintColor = .customOrange
        navigationItem.leftBarButtonItem = leftBarButtonItem
        categoryTextField.delegate = self
    }
    
    @objc private func handleViewDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    internal func createCategory(from name: String?) {
        guard let name = name else { return }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category.setValue(name, forKey: "name")
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCategory(category: category)
            }
        } catch let error {
            print("Failed to save Category", error)
        }
    }
}
