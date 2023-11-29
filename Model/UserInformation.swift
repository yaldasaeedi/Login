//
//  UserInformation.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation


struct UserInformation : Codable{
    
    var mobileNumber : String
    var dialCode: String = PhoneNumberRegionCode.Iran.countryCode
    var regionCode : String = PhoneNumberRegionCode.Iran.countryName
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

