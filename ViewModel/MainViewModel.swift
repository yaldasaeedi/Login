//
//  mainViewModel.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation

class MainViewModel{
    
    var userAutentication : UserAutentication = UserAutentication()
    var userInformation : UserInformation?
    func setingTempToken(){
        
    }
    func checkPhoneNumber(completionHandler: @escaping ( _ result : Result<String, NetworkError>) -> Void, phone : String){
        
        if (userAutentication.isValidPhone(phone: phone)){
            completionHandler(.success(phone))
            
        }else{
            completionHandler(.failure(NetworkError.urlError))
        }
        
        
    }
    func checkVerificationCode(completionHandler: @escaping ( _ result : Result<String, NetworkError>) -> Void, code : String, phone : String){
        APICaller.reciveVerificationSMSFromUser(completionHandler: { result in
            switch result{
            case .success(let token):
                print ("token\(token)")
                completionHandler(.success("success"))
            case .failure(let error):
                
                print ("error\(error)")
                completionHandler(.failure(error))
                
            }
        }, mobileNumber: phone, verificationCode: code)
        
    }
}
