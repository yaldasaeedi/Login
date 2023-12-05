//
//  UserModel.swift
//  Login
//
//  Created by yalda saeedi on 9/8/1402 AP.
//

import Foundation

protocol UserWriter {
    
    func addUser(mobileNumber : String, action : String , token : Token)
}

class UserModel : UserWriter{
    
    private let userStorage: UserStorage
    
    init(userStorage: UserStorage) {
        
        self.userStorage = userStorage
    }
    
    func addUser(mobileNumber : String,  action : String, token : Token)
    {
        let newUser = UserInformation(mobileNumber: mobileNumber ,action : action,  token: token)
        
        userStorage.saveUser(newUser)
        
    }
}
