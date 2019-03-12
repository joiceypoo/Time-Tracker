//
//  TodoItemsControllerDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDelegate,
AddHabitViewDelegate, UIViewControllerTransitioningDelegate {
    func showTextInputArea() {
        isTextInputAreaTapped = true
    }
    
    func didDeleteHabit(todo: TodoItem?) {
        resetNavBar()
        guard let category = todo?.categoryName,
            let todo = todo,
            let section = categories.index(of: category),
            let index = todos[section].value.index(of: todo) else { return }
        
        if todos[section].value.count == 1 {
            let sectionIndexSet = IndexSet(integer: section)
            categories.remove(at: section)
            todos.remove(at: section)
            todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
        } else {
            todos[section].value.remove(at: index)
            let indexPath = IndexPath(row: index, section: section)
            todoListsTable.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(todo)
//        CoreDataManager.shared.recreateHabit(for: todo)
        do {
            try context.save()
        } catch {
            print("Failed deletion: \(error)")
        }
    }
    
    func didEditHabit(todo: TodoItem?, categoryName: String) {
        resetNavBar()
        
        guard
            let name = todo?.categoryName, let todo = todo,
            let section = categories.index(of: categoryName),
            let row = todos[section].value.index(of: todo) else { return }
        
        let todoItem = todos[section].value[row]
        
        if name == categoryName {
            let reloadIndexPath = IndexPath(row: row, section: section)
            todoListsTable.reloadRows(at: [reloadIndexPath], with: .middle)
        } else if !categories.contains(name) {
            guard let section = categories.index(of: categoryName) else { return }
            
            if todos[section].value.count == 1 {
                let sectionIndexSet = IndexSet(integer: section)
                categories.remove(at: section)
                
                var newTodo = todos.remove(at: section)
                todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
                categories.append(name)
                newTodo.key = name
                todos.append(newTodo)
                todoListsTable.reloadData()
            } else if let index = todos[section].value.index(of: todo) {
                todos[section].value.remove(at: index)
                let indexPath = IndexPath(row: index, section: section)
                todoListsTable.deleteRows(at: [indexPath], with: .automatic)
                categories.append(name)
                let newTodo = (key: name, value: [todoItem])
                todos.append(newTodo)
                todoListsTable.reloadData()
            }
        } else if let newSection = categories.index(of: name), newSection == 0 || newSection > 0  {
            if todos[section].value.count == 1 {
                let sectionIndexSet = IndexSet(integer: section)
                categories.remove(at: section)
                todos.remove(at: section)
                todoListsTable.deleteSections(sectionIndexSet, with: .automatic)
                
                if newSection > section {
                    todos[section].value.append(todoItem)
                } else {
                    todos[newSection].value.append(todoItem)
                }
                
                todoListsTable.reloadData()
            } else if let index = todos[section].value.index(of: todo)  {
                todos[section].value.remove(at: index)
                let indexPath = IndexPath(row: index, section: section)
                todoListsTable.deleteRows(at: [indexPath], with: .automatic)
                todos[newSection].value.append(todoItem)
                todoListsTable.reloadData()
            }
        }
    }
    
    func didDismissView() {
        dismissViewHandler()
    }
    
    func didAddHabit(todo: TodoItem) {
        resetNavBar()
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
}
