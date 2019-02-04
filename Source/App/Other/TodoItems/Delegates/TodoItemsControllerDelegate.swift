//
//  TodoItemsControllerDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDelegate, EditTodoControllerDelegate, AddHabitDelegate {
    func didEditTodo(todoItem: TodoItem?) {
        guard let category = todoItem?.categoryName,
            let section = categories.index(of: category),
            let todo = todoItem else { return }
        let row = todos[section].value.index(of: todo)
        let reloadIndexPath = IndexPath(row: row!, section: section)
        todoListsTable.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddHabit(todo: TodoItem) {
        if categories.count == 0, let category = todo.categoryName {
            categories.append(category)
            let newTodo = (key: category, value: [todo])
            todos.append(newTodo)
            todoListsTable.reloadData()
        } else if let category = todo.categoryName, categories.contains(category), let section = categories.index(of: category) {
            var newTodo = todos[section].value
            newTodo.append(todo)
            todos[section].value = newTodo
            todoListsTable.reloadData()
        } else if let category = todo.categoryName {
            categories.append(category)
            let newTodo = (key: category, value: [todo])
            todos.append(newTodo)
            todoListsTable.reloadData()
        }
    }
    
    func handleTodoDeletion(todoItem: TodoItem?) {
        guard let category = todoItem?.categoryName,
            let todo = todoItem,
            let section = categories.index(of: category),
            let index = todos[section].value.index(of: todo) else { return }
        let newIndexPath = IndexPath(row: index, section: section)
        todos[section].value.remove(at: index)
        todoListsTable.deleteRows(at: [newIndexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let editTodoController = EditTodoController.instantiate(from: .main)
            else { return }
        let newTodos = todos[indexPath.section].value
        editTodoController.habitTitle = cell?.textLabel?.text
        editTodoController.delegate = self
        editTodoController.todo = newTodos[indexPath.row]
        let navigationController = CustomNavigationController(rootViewController: editTodoController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete",
                                                handler: deleteHandler)
        return [deleteAction]
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
    
//    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        var row = 0
//        if sourceIndexPath.section != proposedDestinationIndexPath.section {
//            row = todoListsTable.numberOfRows(inSection: sourceIndexPath.section) - 1
//            return IndexPath(row: row, section: sourceIndexPath.section)
//        }
//        return proposedDestinationIndexPath
//    }
}
