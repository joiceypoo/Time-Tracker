//
//  AddTodoController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class AddTodoController: UIViewController {

    @IBOutlet weak var todoItemDetailTable: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.title = "Add Habit"
        view.backgroundColor = .customDarkBlack
        navigationController?.navigationBar.prefersLargeTitles = false
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleDismiss))
        let rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(handleAddTodoItem))
        leftBarButtonItem.tintColor = .customOrange
        rightBarButtonItem.tintColor = .customGray
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoItemDetailTable.indexPathForSelectedRow {
            self.todoItemDetailTable.deselectRow(at: index, animated: true)
        }
    }
    
    @objc private func handleAddTodoItem() {
        print("I am here")
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        notesTextView.backgroundColor = .customBlack
        notesTextView.textColor = .customLightGray
        todoItemDetailTable.separatorColor = .customLightGray
    }
}
