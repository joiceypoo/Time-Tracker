//
//  TodoItemsControllerDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension TodoItemsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let keys2 = Array(todos.keys)
        if categories.count == 0 {
            return 0
        }
        let todosForThisKey = todos[categories[section]]
        let todosCount = todosForThisKey?.count
        return todosCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TodoListCell.instantiate(from: tableView, for: indexPath) else {
            return UITableViewCell()
        }
        
        let categoryIndex = indexPath.section
//        let keys2 = Array(todos.keys)
        let categoryString = categories[categoryIndex]
        cell.viewModel = todos[categoryString]?[indexPath.row]
        return cell
    }
}
