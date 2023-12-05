//
//  mainViewModel.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation

class MainViewModel{
    
    private var userAutentication : UserAutentication = UserAutentication()
    private var userModel : UserModel = UserModel(userStorage: AuthenticationUserDefaults(storageKey: "users"))
    
    private var tempToken : Token?
    
    func setingTempToken(completionHandler: @escaping ( _ result : Result< String , NetworkError>) -> Void) {
        
        APICaller.shared.settingTempTokenForUser { result in
            
            switch result{
                
            case .success(let token):
                
                self.tempToken = token
                completionHandler(.success("success"))
                
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func checkPhoneNumber(completionHandler: @escaping ( _ result : Result<String, NetworkError>) -> Void, phone : String){
        
        if (userAutentication.isValidPhone(phone: phone)){
            
            completionHandler(.success(phone))
            
        }else{
            
            completionHandler(.failure(NetworkError.urlError))
        }
    }
    
    func checkVerificationCode(completionHandler: @escaping ( _ result : Result<String, NetworkError>) -> Void, code : String, phone : String){
        APICaller.shared.reciveVerificationSMSFromUser(completionHandler: { result in
            
            switch result{
                
            case .success(let token):
                                
                self.userModel.addUser(mobileNumber: phone, action: "2", token: token)
            
                completionHandler(.success("success"))
                
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }, mobileNumber: phone, verificationCode: code)
    }
}
