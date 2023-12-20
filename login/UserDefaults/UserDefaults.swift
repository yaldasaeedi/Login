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
    func getUserToken() -> Token?
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
    func getUserToken() -> Token? {
        
        var tempToken : Token?
        let encodedData = userDefaults.data(forKey: storageKey)
            
        do {
                
            let decoder = JSONDecoder()
            let savedUsers = try decoder.decode([UserInformation].self, from: encodedData!)
    
            return savedUsers.last?.token
        } catch {
                
            print("Error occurred while decoding data: \(error)")
        }
        APICaller.shared.settingTempTokenForUser { result in
            switch result{
                
            case .success(let token):
                
                tempToken = token
                
            case .failure(let error):
                
                print(error)
            }
        }
        return tempToken
    }
    
    
}
