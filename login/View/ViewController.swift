//
//  ViewController.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import UIKit
import NotificationBannerSwift

class ViewController: UIViewController {
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneRecuestBTN: UIButton!
    
    private var  tempPhoneNumber : String = ""
   
    private var viewModel : MainViewModel = MainViewModel();
    private var bannerMessage : BannerMessages = BannerMessages()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.phoneRecuestBTN.backgroundColor = .lightGray
        self.phoneRecuestBTN.isEnabled = false
        self.setupTextFields()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.phoneNumberTextField.placeholder = "09123456789"
                
        self.viewModel.setingTempToken { result in
            
            switch result{
                
            case .success(let state):
                
                print(state)
            case .failure(let error):
                
                print(error)
            }
        }
    }

    
    @IBAction func phoneNumberEditing(_ sender: Any) {
        self.tempPhoneNumber = phoneNumberTextField.text ?? ""
        self.viewModel.checkPhoneNumber(completionHandler: {  result in
            
            switch result{
                
            case .success(_):
                DispatchQueue.main.async {
                    self.phoneRecuestBTN.backgroundColor = .blue
                    self.phoneRecuestBTN.isEnabled = true
                }
                

            case .failure(_): 
                DispatchQueue.main.async {
                    self.phoneRecuestBTN.backgroundColor = .lightGray
                    self.phoneRecuestBTN.isEnabled = false
                }

            }
        }, phone : self.tempPhoneNumber)
    }
    
    @IBAction func phoneRecuestBTNClicked(_ sender: Any) {
        
        self.tempPhoneNumber = phoneNumberTextField.text ?? ""
        
        self.viewModel.checkPhoneNumber(completionHandler: { result in
            
            switch result{
                
            case .success(let validPhoneNumber):
                APICaller.shared.sendVerificationSMSToUser(completionHandler: {  result in
                    
                    switch result{
                    case .success(_):
                        
                        DispatchQueue.main.async{
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let codeVerificationVC = storyboard.instantiateViewController(withIdentifier: "CodeVerification") as! CodeVerificationViewController
                            codeVerificationVC.phoneNumber = .init(validPhoneNumber)
                            self.present(codeVerificationVC, animated: true, completion: nil)
                        }
                        
                    case .failure(let error):
                        
                        print(error)
                        DispatchQueue.main.async{
                            
                            self.bannerMessage.showNotificationBanner(for: .systemError)
                        }
                    }
                }, mobileNumber: validPhoneNumber)
                
            case .failure(let error):
                
                print(error)
                DispatchQueue.main.async{
                    
                    self.bannerMessage.showNotificationBanner(for: .unValidPhoneNumber)
                }
            }
        }, phone : self.tempPhoneNumber)
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
            
        phoneNumberTextField.inputAccessoryView = toolbar
           
    }
        
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
