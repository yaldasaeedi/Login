//
//  CodeVerificationViewController.swift
//  login
//
//  Created by yalda saeedi on 9/12/1402 AP.
//

import Foundation
import UIKit
import NotificationBannerSwift

class CodeVerificationViewController : UIViewController{
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var verificationCodeBTN: UIButton!

    private var viewModel : MainViewModel = MainViewModel();
    private var bannerMessage : BannerMessages = BannerMessages()

    public var phoneNumber : String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.verificationCodeBTN.backgroundColor = .lightGray
        self.verificationCodeBTN.isEnabled = false
        
    }
  
    @IBAction func verificationCodeEditing(_ sender: Any) {
        
        if (verificationCodeTextField.text != "" && verificationCodeTextField.text?.count == 4){
            
            self.verificationCodeBTN.backgroundColor = .blue
            self.verificationCodeBTN.isEnabled = true
        }else{
            
            self.verificationCodeBTN.backgroundColor = .lightGray
            self.verificationCodeBTN.isEnabled = false
        }
    }
    
    @IBAction func verificationCodeBTNClicked(_ sender: Any) {
        
        self.viewModel.checkVerificationCode(completionHandler: { [weak self]result in
            
            switch result{
                
            case .success(_):
                DispatchQueue.main.async{
                    self?.bannerMessage.showNotificationBanner(for: .validCode)
                }
                
            case .failure(_):
                
                DispatchQueue.main.async{
                    self?.bannerMessage.showNotificationBanner(for: .unvalidCode)
                }
            }
        }, code: verificationCodeTextField.text ?? "", phone: self.phoneNumber )
    }
    
    @IBAction func sendCodeAgainBTNClicked(_ sender: Any) {
        
        APICaller.shared.sendVerificationSMSToUser(completionHandler: {  result in
                    
            switch result{
                
            case .success(_):
                self.bannerMessage.showNotificationBanner(for: .codeSent)
                
            case .failure(let error):
                print(error)
                        
            }
        }, mobileNumber: self.phoneNumber )
    }

    
}

