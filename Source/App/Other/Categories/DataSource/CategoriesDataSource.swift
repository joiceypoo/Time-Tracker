//
//  CategoriesDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension CategoriesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = CategoriesCell.instantiate(from: tableView, for: indexPath)
            else { return UITableViewCell() }
        if let detailTextLabel = detailLabelText, detailTextLabel == categories[indexPath.row].name {
            cell.accessoryType = .checkmark
            cell.title = categories[indexPath.row].name
        }
        cell.title = categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = DisplayMessage(frame: categoriesTable.frame)
        label.messageLabel.text = "Nothing on your list yet, Tap on the Add button above to add a new category"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return categories.count == 0 ? categoriesTable.frame.height - 200 : 0
    }
}

