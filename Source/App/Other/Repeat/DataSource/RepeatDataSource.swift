//
//  RepeatDataSource.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension RepeatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = RepeatCell.instantiate(from: tableView, for: indexPath)
            else { return UITableViewCell() }
        cell.viewModel = schedules[indexPath.row]
        return cell
    }
    
    
}
