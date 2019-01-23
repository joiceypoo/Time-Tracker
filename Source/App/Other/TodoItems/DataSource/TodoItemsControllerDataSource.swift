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
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TodoListCell.instantiate(from: tableView, for: indexPath) else {
            return UITableViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = DisplayMessage(frame: todoListsTable.frame)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return todoItems.count == 0 ? todoListsTable.frame.height - 200 : 0
    }
}
