//
//  TodoItemsControllerDelegate.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editTodoController = EditTodoController.instantiate(from: .main)
            else { return }
        
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
        let movedTodoItem = todoItems[sourceIndexPath.row]
        todoItems.remove(at: sourceIndexPath.row)
        todoItems.insert(movedTodoItem, at: destinationIndexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentLabel()
        label.backgroundColor = .customDarkBlack
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .customLightGray
        label.text = "Gym Section"
        return label
    }
    
}
