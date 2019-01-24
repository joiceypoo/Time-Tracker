//
//  CustomAddTodoCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 22/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var viewModel: DescriptionVM? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        guard let descriptionText = viewModel
            else { return }
        if descriptionText.title == "Repeat" {
            accessoryType = .disclosureIndicator
        }
        detailTextLabel?.text = descriptionText.details
        textLabel?.text = descriptionText.title
    }
    
    private func setupView() {
        backgroundColor = .customBlack
        textLabel?.textColor = .white
        selectionStyle = .none
    }
}
