//
//  ErrorHandeling.swift
//  login
//
//  Created by yalda saeedi on 9/15/1402 AP.
//

import Foundation

enum NetworkRequestFailedResult : Error{
    
    case urlError
    case canNotPresentData
    case codeIsNotValid
    case phoneIsNotValid
}

enum State {
    
    case unValidPhoneNumber
    case unvalidCode
    case systemError
    case validCode
    case codeSent
}

enum NetworkRequestSuccessResult {
    
    case tempTokenSent
    case userTotenSent
    case verificationCodeSent
    case codeVerified
}

enum userCausedError : Error {
    
    case wrongPhoneNumber
    case wrongverifivationCode
}
