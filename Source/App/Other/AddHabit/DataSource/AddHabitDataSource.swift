//
//  AddTodoDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddHabitController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = TitleCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.titleTextField.delegate = self
            return cell
        } else if indexPath.row == 1 {
            tableView.register(AddHabitCell.self, forCellReuseIdentifier: "AddHabitCell")
            guard let cell = AddHabitCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = DescriptionVM(title: "Repeat", details: "Weekdays")
            return cell
        } else if indexPath.row == 2 {
            tableView.register(AddHabitCell.self, forCellReuseIdentifier: "AddHabitCell")
            guard let cell = AddHabitCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.viewModel = DescriptionVM(title: "Completed", details: "0 times")
            return cell
        } else {
            tableView.register(AddHabitCell.self, forCellReuseIdentifier: "AddHabitCell")
            guard let cell = AddHabitCell.instantiate(from: tableView, for: indexPath) else {
                return UITableViewCell()
            }
            cell.delegate = self
            category = "None"
            cell.viewModel = DescriptionVM(title: "Tag", details: "None")
            return cell
        }
    }
    
    
}
