//
//  CategoriesCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 25/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var title: String? {
        didSet { updateLabel() }
    }
    
    private func updateLabel() {
        guard let title = title
            else { return }
        textLabel?.text = title
        textLabel?.textColor = .white
    }
    
    private func setupView() {
        backgroundColor = .customBlack
        tintColor = .customOrange
        selectionStyle = .none
    }
    
}
