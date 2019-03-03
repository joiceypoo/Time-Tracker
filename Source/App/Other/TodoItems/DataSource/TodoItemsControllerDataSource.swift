//
//  TodoItemsControllerDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if categories.count == 0 {
            let label = DisplayMessage(frame: todoListsTable.frame)
            label.messageLabel.text = "Time to add some habits 🐰🥕"
            todoListsTable.backgroundView = label
            return categories.count
        }
        todoListsTable.backgroundView?.isHidden = true
        return categories.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.count == 0 {
            return 0
        }
        
        let todosForThisKey = todos[section].value
        let todosCount = todosForThisKey.count
        return todosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TodoListCell.instantiate(from: tableView, for: indexPath) else {
            return UITableViewCell()
        }
        let categoryIndex = indexPath.section
        var newTodos = todos[categoryIndex].value
        cell.viewModel = newTodos[indexPath.row]
        return cell
    }
}
