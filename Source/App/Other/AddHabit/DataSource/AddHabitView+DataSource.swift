//
//  AddHabitView+DataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 18/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension AddHabitView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
        if  let categoryName = categories[indexPath.row].name, categoryName != "" {
            cell.textLabel?.text = "# \(categoryName)"
            cell.textLabel?.textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
            cell.selectionStyle = .none
        }
        
        return cell
    }
}
