//
//  EditTodoController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit
protocol EditTodoControllerDelegate {
    func handleTodoDeletion(todoItem: String)
}

public class EditTodoController: UIViewController {

    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var todoItemDetailTable: UITableView!
    
    var textTitle: String?
    var delegate: EditTodoControllerDelegate?
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.todoItemDetailTable.indexPathForSelectedRow {
            self.todoItemDetailTable.deselectRow(at: index, animated: true)
        }
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
    
    @IBAction func handleTodoDelete(_ sender: UIButton) {
        guard let title = textTitle else { return }
        dismiss(animated: true) {
            self.delegate?.handleTodoDeletion(todoItem: title)
        }
    }
    
}
