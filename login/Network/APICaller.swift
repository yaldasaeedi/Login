//
//  APICaller.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation

protocol APIGetRequest {
    
    func sendVerificationSMSToUser(completionHandler: @escaping ( _ result : Result< NetworkRequestSuccessResult , NetworkRequestFailedResult>) -> Void, mobileNumber : String)
    
    func settingTempTokenForUser(completionHandler: @escaping ( _ result : Result<Token, NetworkRequestFailedResult>) -> Void)

}

protocol APIPostRequest {
    
    func reciveVerificationSMSFromUser(completionHandler: @escaping ( _ result : Result<Token, NetworkRequestFailedResult>) -> Void, mobileNumber : String,verificationCode : String)
    
    func ETARequest()
}



class APICaller :APIGetRequest, APIPostRequest{
    
    public static var shared: APICaller = APICaller()
    
    private init(){
        
    }
    private var viewModel : MainViewModel = MainViewModel()
    
    func sendVerificationSMSToUser(completionHandler: @escaping ( _ result : Result< NetworkRequestSuccessResult , NetworkRequestFailedResult>) -> Void, mobileNumber : String) {
        
        let urlString = "\(NetworkConstant.shared.servarAddress)/v3/verification/sms/request?mobileNumber=\(mobileNumber)&uuid=4859532c-8ded-11ee-b9d1-0242ac120002&dialCode=98&regionCode=IR"
        
        guard let url = URL(string: urlString) else{ return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                    
                completionHandler(.failure(error as! NetworkRequestFailedResult))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                    
                completionHandler(.failure(.canNotPresentData))
                return
            }
            
            if httpResponse.statusCode == 200{
                
                completionHandler(.success(.verificationCodeSent))
                
            }else {
                
                completionHandler(.failure(.urlError))
            }
            
        }.resume()
    }
    
    
    func reciveVerificationSMSFromUser(completionHandler: @escaping ( _ result : Result<Token, NetworkRequestFailedResult>) -> Void, mobileNumber : String,verificationCode : String){
        
        let urlString =  "\(NetworkConstant.shared.servarAddress)/v3/verification/sms/verify?mobileNumber=\(mobileNumber)&uuid=4859532c-8ded-11ee-b9d1-0242ac120002&verificationCode=\(verificationCode)&action=2&regionCode=IR"
        
        guard let url = URL(string: urlString) else{ return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
            if let error = error {

                completionHandler(.failure(error as! NetworkRequestFailedResult))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {

                completionHandler(.failure(.canNotPresentData))
                return
            }

            if httpResponse.statusCode == 200,
                let data = data,
                let resultData = try? JSONDecoder().decode(Token.self, from: data){
                
                completionHandler(.success(resultData))
            } else {
                
                completionHandler(.failure(.canNotPresentData))
            }
        }.resume()
    }
    
    
    func settingTempTokenForUser(completionHandler: @escaping ( _ result : Result<Token, NetworkRequestFailedResult>) -> Void){
        
        let urlString = "\(NetworkConstant.shared.servarAddress)/v1/user/temp?uuid=4859532c-8ded-11ee-b9d1-0242ac120002"
        
        guard let url = URL(string: urlString) else{ return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                    
                completionHandler(.failure(error as? NetworkRequestFailedResult ?? .urlError ))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                
                completionHandler(.failure(.canNotPresentData))
                return
            }
            
        if httpResponse.statusCode == 200,
            let data = data,
            let resultData = try? JSONDecoder().decode(Token.self, from: data) {
            
                completionHandler(.success(resultData))
                
            } else {
                
                completionHandler(.failure(.canNotPresentData))
            }
        }.resume()
    }
    
    func ETARequest(){
        
        let urlString = "https://routing.neshanmap.ir/v4.2/eta"
        
        guard let url = URL(string: urlString) else{ return }
        
        var urlRequest = URLRequest(url: url)
        
//        var requestBodyComponents = URLComponents()
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("okhttp_VC: 70147_UUID: test", forHTTPHeaderField: "User-Agent")
        
        let requestBody = "resName=res1&uuid=4859532c-8ded-11ee-b9d1-0242ac120002&datasetName=primary&origin={\"noneSnapped\":{\"isUserLocation\":true,\"lat\":36.29022899999998,\"lng\":59.616005}}&destination={\"lat\":36.200693060010465,\"lng\":59.401448230279264}&appState="
        urlRequest.httpBody = requestBody.data(using: .utf8)
     
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("httpResponse");
                return
            }
            print(httpResponse.statusCode)
            if httpResponse.statusCode == 200,
               let data = data,
               let resultData = try? JSONDecoder().decode(ETRInformation.self, from: data) {
                
                print(resultData)
                
                guard let duDecoding = resultData.res.data.r.first?.du else{
                    print("du is empty")
                    return
                }
                guard let dsDecoding = resultData.res.data.r.first?.ds else{
                    print("ds is empty")
                    return
                }
                if let data = Data(base64Encoded : duDecoding ) {
                    
                    if let decodedString = String(data: data, encoding: .utf8) {
                        
                        print(decodedString)
                    }
                } else {
                    print("Failed to decode the Base64 string.")
                }
                if let data = Data(base64Encoded : dsDecoding ) {
                    
                    if let decodedString = String(data: data, encoding: .utf8) {
                        
                        print(decodedString)
                    }
                } else {
                    print("Failed to decode the Base64 string.")
                }
            }
        }.resume()
        
    }
}

