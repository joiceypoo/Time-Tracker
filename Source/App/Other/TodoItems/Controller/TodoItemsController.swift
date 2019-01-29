//
//  ViewController.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit
import CoreData

class TodoItemsController: UIViewController {

    var todoItems: [String] = ["Exercise at home",
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
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var todoListsTable: UITableView!
    
    let topBorder = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "To do"
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(handleLongPress(recognizer:)))
        todoListsTable.addGestureRecognizer(longPressedGestureRecognizer)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoListsTable.indexPathForSelectedRow {
            self.todoListsTable.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topBorder.frame = CGRect(x: 0, y: 1, width: calenderView.bounds.width, height: 0.3)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let state = recognizer.state
        let locationInView = recognizer.location(in: todoListsTable)
        let indexPath = todoListsTable.indexPathForRow(at: locationInView)
        switch state {
        case .began:
            gestureBeganHandler(indexPath, locationInView)
        case .changed:
            gestureChangedHandler(locationInView, indexPath)
        default:
            handleDefault()
        }
    }
    
    private func setupView() {
        topBorder.frame = CGRect(x: 0,
                                 y: 1,
                                 width: calenderView.bounds.width,
                                 height: 0.3)
        topBorder.backgroundColor = UIColor.customLightGray.cgColor
        calenderView.backgroundColor = .customBlack
        calenderView.layer.addSublayer(topBorder)
        
        todoListsTable.backgroundColor = .customDarkBlack
        todoListsTable.separatorColor = .customLightGray
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




