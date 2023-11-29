//
//  UserAutentication.swift
//  Login
//
//  Created by yalda saeedi on 9/7/1402 AP.
//

import Foundation

class UserAutentication{
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^09[0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
}
