//
//  UserAutentication.swift
//  Login
//
//  Created by yalda saeedi on 9/7/1402 AP.
//

import Foundation

enum PhoneNumberRegionCode: String {
    case US = "1"
    case UK = "44"
    case Iran = "98"
    var countryCode: String {
        return self.rawValue
    }
    var countryName: String {
            switch self {
            case .US:
                return "US"
            case .UK:
                return "UK"
            case .Iran:
                return "IR"
            }
    }
}

class UserAutentication{
    
    
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
}
