//
//  RepeatDelegates.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

extension RepeatController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? RepeatCell,
            cell.accessoryType.rawValue == 3 && cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            removeItemFromWeekDaysArray(item: cell.viewModel!)
        } else if let cell = tableView.cellForRow(at: indexPath) as? RepeatCell {
            cell.accessoryType = .checkmark
            addItemToWeekDaysArray(item: cell.viewModel!)
        }
    }
}
