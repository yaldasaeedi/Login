//
//  mainViewModel.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation

class MainViewModel{
    
    var userAutentication : UserAutentication = UserAutentication()
    var userModel : UserModel = UserModel(userStorage: AuthenticationUserDefaults(storageKey: "users"))
    var tempToken : Token?
    
    func setingTempToken(completionHandler: @escaping ( _ result : Result< Token , NetworkError>) -> Void) {
        
        APICaller.settingTempTokenForUser { result in
            
            switch result{
                
            case .success(let token):
                
                print(token)
                completionHandler(.success(token))
                
            case .failure(let error):
                
                print(error)
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
    
    func checkVerificationCode(completionHandler: @escaping ( _ result : Result<String, NetworkError>) -> Void, code : String, phone : String, regionCode : String, dialCode : String){
        
        APICaller.reciveVerificationSMSFromUser(completionHandler: { result in
            
            switch result{
                
            case .success(let token):
                
                print ("token\(token)")
                self.setingTempToken { result in
                    
                    switch result{
                        
                    case .success(let tempToken):
                        
                        print(tempToken)
                        self.tempToken = tempToken
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
                self.userModel.addUser(mobileNumber: phone, dialCode: dialCode, regionCode: regionCode, action: "2", tempToken: self.tempToken ?? token, userToken: token)
            
                completionHandler(.success("success"))
                
            case .failure(let error):
                
                print ("error\(error)")
                completionHandler(.failure(error))
            }
        }, mobileNumber: phone, verificationCode: code, regionCode: regionCode)
    }
}
