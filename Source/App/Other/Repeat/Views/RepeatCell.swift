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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var viewModel: String? {
        didSet { bindViewModel() }
    }
    
    var weekdays: [String] = []
    
    private func bindViewModel() {
        guard let title = viewModel
            else { return }
        textLabel?.text = "Every \(title)"
        textLabel?.textColor = .white
    }
    
    private func setupView() {
        backgroundColor = .customBlack
        tintColor = .customOrange
        accessoryType = .checkmark
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectedBackgroundView = view
    }
}
