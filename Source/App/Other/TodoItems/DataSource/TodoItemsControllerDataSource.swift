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
        let label = UILabel(frame: CGRect(x: 200,
                                          y: 200,
                                          width: self.todoListsTable.bounds.size.width,
                                          height: todoListsTable.bounds.size.height))
        label.text = "Nothing on your list yet, Tap the plus button below to add a new item"
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return todoItems.count == 0 ? 290: 0
    }
}
