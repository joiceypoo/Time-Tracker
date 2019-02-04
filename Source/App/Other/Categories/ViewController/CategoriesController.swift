//
//  CategoriesController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {

    @IBOutlet weak var categoriesTable: UITableView!
    
    var categories: [Category] = []
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = CoreDataManager.shared.fetchCategories()
        view.backgroundColor = .customDarkBlack
        navigationController?.navigationBar.tintColor = .customOrange
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedCategory = selectedCategory, self.isMovingFromParent {
            NotificationCenter.default.post(name: .postCategory,
                                            object: nil,
                                            userInfo: ["postCategory": selectedCategory])
        }
    }
    
    private func setupView() {
        navigationItem.title = "Categories"
        let rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addCategoriesHandler))
        rightBarButtonItem.tintColor = .customOrange
        navigationItem.rightBarButtonItem = rightBarButtonItem
        categoriesTable.separatorColor = .customLightGray
        categoriesTable.tableFooterView = UIView()
    }
    
    @objc private func addCategoriesHandler() {
        guard let addCategoryController = AddCategoryController.instantiate(from: .main)
            else { return }
        addCategoryController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: addCategoryController)
        present(navigationController, animated: true, completion: nil)
    }
    
    public func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        let category = categories[indexPath.row]
        categories.remove(at: indexPath.row)
        categoriesTable.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(category)
        do {
            try context.save()
        } catch {
            print("Failed deletion: \(error)")
        }
    }
}
