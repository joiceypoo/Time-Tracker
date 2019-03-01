//
//  TodoItemsControllerDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDelegate, EditTodoControllerDelegate, AddHabitDelegate,
AddHabitViewDelegate, UIViewControllerTransitioningDelegate {
    func showTextInputArea() {
        isTextInputAreaTapped = true
    }
    
    func didDeleteHabit(todo: TodoItem?) {
        guard let category = todo?.categoryName,
            let todo = todo,
            let section = categories.index(of: category),
            let index = todos[section].value.index(of: todo) else { return }
        let newIndexPath = IndexPath(row: index, section: section)
        todos[section].value.remove(at: index)
        todoListsTable.deleteRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditHabit(todo: TodoItem?) {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        displayHabitView = false
        guard let category = todo?.categoryName,
            let section = categories.index(of: category),
            let todo = todo,
            let row = todos[section].value.index(of: todo) else { return }
        let reloadIndexPath = IndexPath(row: row, section: section)
        todoListsTable.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didDismissView() {
        dismissViewHandler()
    }
    
    func didEditTodo(todoItem: TodoItem?) {
        guard let category = todoItem?.categoryName,
            let section = categories.index(of: category),
            let todo = todoItem,
            let row = todos[section].value.index(of: todo) else { return }
        let reloadIndexPath = IndexPath(row: row, section: section)
        todoListsTable.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddHabit(todo: TodoItem) {
        displayHabitView = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if categories.count == 0, let category = todo.categoryName {
            categories.append(category)
            let newTodo = (key: category, value: [todo])
            todos.append(newTodo)
            todoListsTable.reloadData()
        } else if let category = todo.categoryName, categories.contains(category),
            let section = categories.index(of: category) {
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
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayHabitView.toggle()
        let newTodos = todos[indexPath.section].value
        let todo = newTodos[indexPath.row]
        setupAddHabitView(for: todo)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete",
                                                handler: deleteHandler)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if categories.isEmpty {
            return 0
        } else if categories.count == 1 && categories.contains("None") {
            return 20
        }
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentLabel()
        label.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        if categories.count == 1 && categories.contains("None") {
            label.text = ""
        } else if categories[section] == "None" {
            label.text = "No Tags"
        } else {
            label.text = categories[section]
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = DisplayMessage(frame: todoListsTable.frame)
        label.messageLabel.text = "Time to add some habits 🐰🥕"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return todos.count == 0 ? todoListsTable.frame.height - 200 : 0
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
}
