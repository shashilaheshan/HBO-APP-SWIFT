//
//  Validator.swift
//  HBO
//
//  Created by Shashila Heshan on 14/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import Foundation
class ValidateFields {
    
    func usernameValid(username : String) -> Bool {
        return username.count > 5
    }
    func passwordValid(password : String) -> Bool {
        return password.count > 8
    }
    
}
