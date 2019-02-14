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
    func didEditCategory(category: Category)
}

class AddCategoryController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    public var delegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let category = category {
            categoryTextField.text = category.name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categoryTextField.becomeFirstResponder()
    }
    
    var category: Category?
    
    func createCategory(from name: String?) {
        guard let name = name else { return }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category",
                                                           into: context) as! Category
        category.setValue(name,
                          forKey: "name")
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCategory(category: category)
            }
        } catch let error {
            print("Failed to save Category", error)
        }
    }
    
    func saveChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        category?.name = categoryTextField.text
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCategory(category: self.category!)
            }
        } catch let error {
            print("Failed to save changes", error)
        }
    }
    
    @objc private func handleViewDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        navigationItem.title = category == nil ? "Category": "Edit Category"
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
}
