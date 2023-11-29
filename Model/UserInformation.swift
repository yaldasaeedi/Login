//
//  UserInformation.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation


struct UserInformation : Codable{
    
    var mobileNumber : String
    var uuid : String = "056e5f9c-8cfa-11ee-b9d1-0242ac120002"
    var dialCode: String = "98"
    var regionCode : String = "IR"
    var action : String = "2"
    var tempToken: Token
    var userToken : Token
}

struct Token: Codable {
    let scope, accessToken, tokenType, refreshToken: String
    let expiresIn: String

    enum CodingKeys: String, CodingKey {
        case scope
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}

