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
    
    func setingTempToken(completionHandler: @escaping ( _ result : Result< NetworkRequestSuccessResult , NetworkRequestFailedResult>) -> Void) {
        
        APICaller.shared.settingTempTokenForUser { result in
            
            switch result{
                
            case .success(let token):
                
                self.tempToken = token
                completionHandler(.success(.tempTokenSent))
                
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func checkPhoneNumber(completionHandler: @escaping ( _ result : Result<String, userCausedError>) -> Void, phone : String){
        
        if (userAutentication.isValidPhone(phone: phone)){
            
            completionHandler(.success(phone))
            
        }else{
            
            completionHandler(.failure(.wrongPhoneNumber))
        }
    }
    
    func sendVerificationCode(completionHandler: @escaping ( _ result : Result<String, NetworkRequestFailedResult>) -> Void, validPhoneNumber : String){
        
        APICaller.shared.sendVerificationSMSToUser(completionHandler: {  result in
            
            switch result{
            case .success(_):
                
                completionHandler(.success(validPhoneNumber))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }, mobileNumber: validPhoneNumber)
    }
    
    func checkVerificationCode(completionHandler: @escaping ( _ result : Result<NetworkRequestSuccessResult, NetworkRequestFailedResult>) -> Void, code : String, phone : String){
        
        APICaller.shared.reciveVerificationSMSFromUser(completionHandler: { result in
            
            switch result{
                
            case .success(let token):
                                
                self.userModel.addUser(mobileNumber: phone, action: "2", token: token)
            
                completionHandler(.success(.codeVerified))
                
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }, mobileNumber: phone, verificationCode: code)
    }
}
