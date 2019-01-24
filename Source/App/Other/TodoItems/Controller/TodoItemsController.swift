//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class TodoItemsController: UIViewController {

    var todoItems: [String] = ["Test One",
                               "Test Two",
                               "Test Three",
                               "Test Four",
                               "Test Five",
                               "Test Six",
                               "Test Seven",
                               "Test Eight",
                               "Test Nine",
                               "Test Ten"
    ]
    
    @IBOutlet weak var todoListsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To do"
        setupView()
    }
    
    private func setupView() {
        todoListsTable.backgroundColor = .customDarkBlack
        todoListsTable.tableFooterView = UIView()
    }
    
    @IBAction private func addTodoItemButtonPressed(_ sender: AddButton) {
        guard let addTodoController = AddTodoController.instantiate(from: .main)
            else { return }
        let navController = CustomNavigationController(rootViewController: addTodoController)
        present(navController, animated: true, completion: nil)
    }
    
    public func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) {
//        let todoItem = todoItems[indexPath.row]
        todoItems.remove(at: indexPath.row)
        todoListsTable.deleteRows(at: [indexPath], with: .automatic)
    }
    
    public func editHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        guard let editTodoController = EditTodoController.instantiate(from: .main)
            else { return }
        let navigationController = CustomNavigationController(rootViewController: editTodoController)
        present(navigationController, animated: true, completion: nil)
    }
}




