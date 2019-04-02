//
//  NotesTextView.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 27/03/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class NotesTextView: UITextView {
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func  textDidChange() {
        if text == "Add notes" {
            textColor = #colorLiteral(red: 0.6470588235, green: 0.6588235294, blue: 0.662745098, alpha: 1)
        } else {
           textColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1843137255, alpha: 1)
        }
    }
}
