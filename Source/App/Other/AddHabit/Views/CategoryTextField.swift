//
//  CategoryTextField.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 24/03/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class CategoryTextField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: self)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func  textDidChange() {
        guard let textToFormat = text else { return }
        
        if textToFormat.isLowercase {
            text = textToFormat.capitalized
        } else {
            text = textToFormat
        }
    }
}
