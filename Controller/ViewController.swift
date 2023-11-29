//
//  ViewController.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var phoneRecuestBTN: UIButton!
    @IBOutlet weak var verificationCodeBTN: UIButton!
    var viewModel : MainViewModel = MainViewModel();
    var userInformation : UserInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.phoneNumberTextField.placeholder = "enter your number"
        self.verificationCodeTextField.placeholder = "enter your verification code"
    }
    
    
    
    @IBAction func phoneRecuestBTNClicked(_ sender: Any) {
        
        viewModel.checkPhoneNumber(completionHandler: { [weak self] result in
            
            switch result{
                
            case .success(let validPhoneNumber):
                APICaller.sendVerificationSMSToUser(completionHandler: {  result in
                        
                        switch result{
                        case .success(let userInformation):
                            self?.userInformation?.mobileNumber = validPhoneNumber
                            DispatchQueue.main.async{
                                self?.phoneRecuestBTN.titleLabel?.text = "code sent"
                                self?.phoneNumberTextField.isEnabled = false
                            }
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async{
                                self?.phoneNumberTextField.text = ""
                                self?.phoneNumberTextField.placeholder = "something went wrong, please try again"
                            }
                        }
                }, mobileNumber: validPhoneNumber)
            case .failure(let error):
                print(error)
                self?.phoneNumberTextField.text = ""
                self?.phoneNumberTextField.placeholder = "your phone number is not valid"
                
            }
        }, phone : phoneNumberTextField.text ?? "")
    }
    
    @IBAction func verificationCodeBTNClicked(_ sender: Any) {
        
        viewModel.checkVerificationCode(completionHandler: { result in
        
            switch result{
            case .success(let userToken):
                //DispatchQueue.main.async{
                    print("you enter successfuly")
                    print(userToken)
               // }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async{
                    self.verificationCodeTextField.text = ""
                    self.verificationCodeTextField.placeholder = "your varification code is wrong"
                }
            }
            
        }, code: verificationCodeTextField.text ?? "", phone: self.userInformation?.mobileNumber ?? "9")
    }
}

