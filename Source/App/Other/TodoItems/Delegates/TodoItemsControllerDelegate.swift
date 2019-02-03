//
//  TodoItemsControllerDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDelegate, EditTodoControllerDelegate, AddHabitDelegate {
    func didAddHabit(todo: TodoItem, category: String?) {
//        fetchTodos()
//        if let section = categories.index(of: category!) {
//
//        } else {
//            categories.append(category!)
//        }
//        let newTodos = CoreDataManager.shared.fetchAllTodos()
//        let cat = Array(newTodos.keys)
//        guard let category = category, let section = cat.index(of: category)  else { return }
//        let row = newTodos[category]?.count
//        let insertionIndex = IndexPath(row: row!, section: section + 1)
//        todos[category]?.append(todo)
//        todoListsTable.insertRows(at: [insertionIndex], with: .middle)
    }
    
    func handleTodoDeletion(todoItem: String) {
//        guard let index = todoItems.index(of: todoItem) else { return }
//        todoItems.remove(at: index)
        todoListsTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let editTodoController = EditTodoController.instantiate(from: .main),
            let todos = todos[categories[indexPath.section]]
            else { return }
        
        editTodoController.textTitle = cell?.textLabel?.text
        editTodoController.delegate = self
        editTodoController.todo = todos[indexPath.row]
        let navigationController = CustomNavigationController(rootViewController: editTodoController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete",
                                                handler: deleteHandler)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableView.isEditing = true
//        let movedTodoItem = todoItems[sourceIndexPath.row]
//        todoItems.remove(at: sourceIndexPath.row)
//        todoItems.insert(movedTodoItem, at: destinationIndexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count == 0 ? 1: categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentLabel()
        label.backgroundColor = .customDarkBlack
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .customLightGray
        if categories.count == 0 {
            label.text = ""
        } else {
            label.text = categories[section]
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = DisplayMessage(frame: todoListsTable.frame)
        label.messageLabel.text = "Nothing on your list yet, Tap the plus button below to add a new item"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return todos.count == 0 ? todoListsTable.frame.height - 200 : 0
    }
    
}
