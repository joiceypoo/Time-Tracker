//
//  EditTodoController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class EditTodoController: UIViewController {

    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var todoItemDetailTable: UITableView!
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .customDarkBlack
        navigationItem.title = "Edit"
        navigationController?.navigationBar.prefersLargeTitles = false
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                style: .plain,
                                                target: self,
                                                action: #selector(handleViewDismiss))
        let rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(handleDoneAction))
        leftBarButtonItem.tintColor = .customOrange
        rightBarButtonItem.tintColor = .customOrange
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        notesTextView.backgroundColor = .customBlack
        notesTextView.textColor = .customLightGray
        todoItemDetailTable.separatorColor = .customLightGray
        deleteView.backgroundColor = .customBlack
    }
    
    @objc private func handleViewDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneAction() {
        
    }
}