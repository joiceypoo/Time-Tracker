//
//  CategoriesDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension CategoriesController: UITableViewDelegate, AddCategoryDelegate {
    func didAddCategory(category: Category) {
        
        if categories.isEmpty {
            categories.append(category)
            let indexPath = IndexPath(row: 0, section: 0)
            categoriesTable.insertRows(at: [indexPath], with: .automatic)
            selectedCategory = category.name
            postSelectedCategory()
            navigationController?.popViewController(animated: true)
        } else {
            categories.append(category)
            let newIndexPath = IndexPath(row: categories.count - 1, section: 0)
            categoriesTable.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func didEditCategory(category: Category) {
        let row = categories.index(of: category)
        let newIndexPath = IndexPath(row: row!, section: 0)
        categoriesTable.reloadRows(at: [newIndexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoriesCell, let category = cell.textLabel?.text {
            selectedCategory = category
            cell.accessoryType = .checkmark
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete",
                                                handler: deleteHandler)
        let editAction = UITableViewRowAction(style: .normal,
                                              title: "Edit",
                                              handler: editHandler)
        editAction.backgroundColor = UIColor.customDarkBlack

        
        return [deleteAction, editAction]
    }
}
