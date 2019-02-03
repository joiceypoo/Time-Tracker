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
    
    var todo: TodoItem? {
        didSet { bindViewModel() }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .customBlack
        todoItemTitle?.textColor = .white
    }
    
    private func bindViewModel() {
        guard let todo = todo else { return }
        todoItemTitle.text = todo.title
    }
}
