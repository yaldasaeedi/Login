//
//  APICaller.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation
enum NetworkError : Error {
    case urlError
    case canNotPresentData
}
public class APICaller{
        
    static func sendVerificationSMSToUser(completionHandler: @escaping ( _ result : Result< String , NetworkError>) -> Void, mobileNumber : String, regionCode : String, dialCode: String ) {
        let urlString = "\(NetworkConstant.shared.servarAddress)/v3/verification/sms/request?mobileNumber=\(mobileNumber)&uuid=4859532c-8ded-11ee-b9d1-0242ac120002&dialCode=\(dialCode))&regionCode=\(regionCode)"
        guard let url = URL(string: urlString) else{ return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
                if let error = error {
                    completionHandler(.failure(error as! NetworkError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(.canNotPresentData))
                    return
                }
            
            if httpResponse.statusCode == 200{
                           completionHandler(.success(""))
                
            } else {
                completionHandler(.failure(.canNotPresentData))
            }
        }.resume()
    }
    static func reciveVerificationSMSFromUser(completionHandler: @escaping ( _ result : Result<Token, NetworkError>) -> Void, mobileNumber : String,verificationCode : String , regionCode : String){
        print(verificationCode)
        let urlString = "\(NetworkConstant.shared.servarAddress)/v3/verification/sms/verify?mobileNumber\(mobileNumber)&uuid=4859532c-8ded-11ee-b9d1-0242ac120002&verificationCode=\(verificationCode)&action=2&regionCode=\(regionCode)"
        guard let url = URL(string: urlString) else{ return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error as! NetworkError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(.canNotPresentData))
                    return
                }
            
            
            print(httpResponse.statusCode)
            
            if httpResponse.statusCode == 200,
                let data = data,
                let resultData = try? JSONDecoder().decode(Token.self, from: data)
            {
                print("data:\n")
                print(data)
                completionHandler(.success(resultData))
                
            } else {
                completionHandler(.failure(.canNotPresentData))
            }
        }.resume()
    }
    static func settingTempTokenForUser(completionHandler: @escaping ( _ result : Result<Token, NetworkError>) -> Void){
        let urlString = "\(NetworkConstant.shared.servarAddress)/v1/user/temp"
        guard let url = URL(string: urlString) else{ return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error as! NetworkError))
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

}

