//
//  EditTodoCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 24/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class EditTodoCell: UITableViewCell {
    
    @IBOutlet weak var todoItemTitle: UITextField!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .customBlack
        todoItemTitle.text = "Amazon"
        todoItemTitle?.textColor = .white
    }
}
