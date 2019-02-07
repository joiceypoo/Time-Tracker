//
//  EditTodoDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 24/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension EditTodoController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = EditTodoCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.todo = todo
            habitTitle = cell.todoItemTitle.text
            cell.todoItemTitle.delegate = self
            return cell
        } else if indexPath.row == 1 {
            tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
            guard let cell = CustomCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.viewModel = EditViewModel(todo: todo!, index: indexPath.row)
            weekdays = Unarchive.unarchiveStringArrayData(from: todo?.repeatTodos?.weekday)
            cell.delegate = self
            return cell
        } else if indexPath.row == 2 {
            tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
            guard let cell = CustomCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.viewModel = EditViewModel(todo: todo!, index: indexPath.row)
            return cell
        } else {
            tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
            guard let cell = CustomCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.viewModel = EditViewModel(todo: todo!, index: indexPath.row)
            cell.delegate = self
            category = cell.detailTextLabel?.text
            return cell
        }
    }
    
}
