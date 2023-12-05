//
//  BannerMessages.swift
//  login
//
//  Created by yalda saeedi on 9/14/1402 AP.
//

import Foundation
import NotificationBannerSwift

struct BannerMessages{
    
    enum State  {
        case unValidPhoneNumber
        case unvalidCode
        case systemError
        case validCode
        case codeSent
    }
    
    func showNotificationBanner(for state: State) {
        
        switch state{
            
        case .unValidPhoneNumber:
            let URLErrorBanner = NotificationBanner(title: "خطا",
                                                    subtitle: "شماره شما اشتباه است٬ لطفا پس از اصلاح دوباره امتحان کنید",
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .danger,
                                                    colors: nil)
            URLErrorBanner.show()
            
        case .systemError:
            let URLErrorBanner = NotificationBanner(title: "خطا",
                                                    subtitle: "مشکلی در سرور به وجود آمده٬ لطفا دوباره امتحان کنید",
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .warning,
                                                    colors: nil)
            URLErrorBanner.show()
        case .validCode :
            let URLErrorBanner = NotificationBanner(title: "موفقیت",
                                                    subtitle: "شما با موفقیت وارد شدید",
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .success,
                                                    colors: nil)
            URLErrorBanner.show()
            
        case .unvalidCode:
            let URLErrorBanner = NotificationBanner(title: "خطا",
                                                    subtitle: "کد وارد شده درست نمیباشد٬ لطفا دوباره امتحان کنید",
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .danger,
                                                    colors: nil)
            URLErrorBanner.show()
            
        case .codeSent:
            let URLErrorBanner = NotificationBanner(title: "موفقیت",
                                                    subtitle: "کد برای شما ارسال شد",
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .success,
                                                    colors: nil)
            URLErrorBanner.show()

        }
    }
}
