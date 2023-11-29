//
//  UserModel.swift
//  Login
//
//  Created by yalda saeedi on 9/8/1402 AP.
//

import Foundation

protocol UserWriter {
    
    func addUser(mobileNumber : String, dialCode: String , regionCode : String , action : String, tempToken: Token , userToken : Token)
}

class UserModel : UserWriter{
    
    private let userStorage: UserStorage
    
    init(userStorage: UserStorage) {
        
        self.userStorage = userStorage
    }
    
    func addUser(mobileNumber : String, dialCode: String , regionCode : String , action : String, tempToken: Token , userToken : Token)
    {
        let newUser = UserInformation(mobileNumber: mobileNumber , dialCode: dialCode, regionCode: regionCode, action : action, tempToken: tempToken, userToken: userToken)
        
        userStorage.saveUser(newUser)
        
    }
}
