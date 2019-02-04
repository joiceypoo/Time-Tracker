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
        categories.append(category)
        let newIndexPath = IndexPath(row: categories.count - 1, section: 0)
        categoriesTable.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoriesCell, let category = cell.textLabel?.text {
            selectedCategory = category
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), cell.accessoryType.rawValue == 3,
            let category = cell.textLabel?.text {
            selectedCategory = category
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: "Delete",
                                                handler: deleteHandler)
        return [deleteAction]
    }
}
