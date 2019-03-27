//
//  String+Extension.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 24/03/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import Foundation

extension String {
    
    var isLowercase: Bool {
        return self == self.lowercased()
    }
    
    var isUppercase: Bool {
        return self == self.uppercased()
    }
}
