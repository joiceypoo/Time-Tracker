//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class TodoItemsController: UIViewController {

    var todoItems: [Int] = []
    @IBOutlet weak var todoListsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To do"
        todoListsTable.backgroundColor = .customDarkBlack
        setupView()
    }
    
    private func setupView() {

    }
    
    @IBAction private func addTodoItemButtonPressed(_ sender: AddButton) {
        guard let addTodoController = AddTodoController.instantiate(from: .main)
            else { return }
        let navController = CustomNavigationController(rootViewController: addTodoController)
        present(navController, animated: true, completion: nil)
    }
}




