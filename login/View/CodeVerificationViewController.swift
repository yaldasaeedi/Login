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
        self.setupTextFields()
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
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let ETRViewControllerVC = storyboard.instantiateViewController(withIdentifier: "ETRViewController") as! ETRViewController
                    self?.present(ETRViewControllerVC, animated: true, completion: nil)

                    
                }
                
            case .failure(_):
                
                DispatchQueue.main.async{
                    self?.bannerMessage.showNotificationBanner(for: .unvalidCode)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let ETRViewControllerVC = storyboard.instantiateViewController(withIdentifier: "ETRViewController") as! ETRViewController
                    self?.present(ETRViewControllerVC, animated: true, completion: nil)

                }
            }
        }, code: verificationCodeTextField.text ?? "", phone: self.phoneNumber )
    }
    
    @IBAction func sendCodeAgainBTNClicked(_ sender: Any) {
        self.viewModel.sendVerificationCode(completionHandler: { result in
            
            switch result{
                
            case .success(_):
                
                DispatchQueue.main.async{
                    
                    self.bannerMessage.showNotificationBanner(for: .codeSent)
                }
                
            case .failure(_):
                
                DispatchQueue.main.async{
                    self.bannerMessage.showNotificationBanner(for: .systemError)
                }
                        
            }
        }, validPhoneNumber: self.phoneNumber)
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                        target: self, action: #selector(doneButtonTapped))
        
        doneButton.tintColor = .lightGray
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
            
        verificationCodeTextField.inputAccessoryView = toolbar
           
    }
        
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}


