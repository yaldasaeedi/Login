//
//  UserDefaults.swift
//  Login
//
//  Created by yalda saeedi on 9/8/1402 AP.
//

import Foundation

protocol UserStorage {
    
    func saveUser(_ user: UserInformation)
    func fetchUsers() -> [UserInformation]
}

class AuthenticationUserDefaults : UserStorage{
    
    private let userDefaults = UserDefaults.standard
    private var storageKey: String
    
    init(storageKey: String) {
        
        self.storageKey = storageKey
    }
    
    public func saveUser(_ user: UserInformation) {

        var savedUsers = fetchUsers()
        
        savedUsers.append(user)
        
        do {
            
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(savedUsers)
            
            userDefaults.set(encodedData, forKey: storageKey)
        } catch {
            
            print("Error occurred while encoding data: \(error)")
        }
    }
    
    internal func fetchUsers() -> [UserInformation] {
        
        guard let encodedData = userDefaults.data(forKey: storageKey) else {
            return []
        }
        
        do {
            
            let decoder = JSONDecoder()
            let savedUsers = try decoder.decode([UserInformation].self, from: encodedData)
            
            return savedUsers
        } catch {
            
            print("Error occurred while decoding data: \(error)")
            
            return []
        }
    }
    
}
