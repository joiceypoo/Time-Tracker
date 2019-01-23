//
//  RepeatCell.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 23/01/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

class RepeatCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var viewModel: String? {
        didSet { bindViewModel() }
    }
    
    private func bindViewModel() {
        guard let title = viewModel
            else { return }
        textLabel?.text = title
        textLabel?.textColor = .white
    }
    
    private func setupView() {
        backgroundColor = .customDarkGray
        tintColor = .customOrange
        selectionStyle = .none
    }
}
