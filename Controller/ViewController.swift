//
//  ViewController.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var phoneRecuestBTN: UIButton!
    @IBOutlet weak var verificationCodeBTN: UIButton!
    @IBOutlet weak var regionNumberPickerView: UIPickerView!
    
    var tempPhoneNumber : String = ""
    var tempRegionCode : String = ""
    var tempDialCode : String = ""
    var pickerData: [String] = [PhoneNumberRegionCode.US.countryName, PhoneNumberRegionCode.UK.countryName, PhoneNumberRegionCode.Iran.countryName ]
    var viewModel : MainViewModel = MainViewModel();
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.regionNumberPickerView.delegate = self
        self.regionNumberPickerView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.phoneNumberTextField.placeholder = "enter your number"
        self.verificationCodeTextField.placeholder = "enter your verification code"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedTitle = pickerData[row]
            self.tempRegionCode = selectedTitle
            if let regionCode = PhoneNumberRegionCode(rawValue: selectedTitle) {
                self.tempDialCode = regionCode.countryCode
            } else {
                self.tempDialCode = ""
            }
            print("Selected title: \(selectedTitle)")
            
            print("Selected row: \(row)")
        }
    @IBAction func phoneRecuestBTNClicked(_ sender: Any) {
        self.tempPhoneNumber = phoneNumberTextField.text ?? ""
        
        viewModel.checkPhoneNumber(completionHandler: { [weak self] result in
            
            switch result{
                
            case .success(let validPhoneNumber):
                APICaller.sendVerificationSMSToUser(completionHandler: {  result in
                        
                        switch result{
                        case .success(let userInformation):
                            DispatchQueue.main.async{
                                
                                self?.phoneNumberTextField.text = "code sent"
                                self?.phoneNumberTextField.isEnabled = false
                            }
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async{
                                self?.phoneNumberTextField.text = ""
                                self?.phoneNumberTextField.placeholder = "something went wrong, please try again"
                            }
                        }
                }, mobileNumber: validPhoneNumber, regionCode: self?.tempRegionCode ?? "", dialCode: self?.tempDialCode ?? "")
            case .failure(let error):
                print(error)
                self?.phoneNumberTextField.text = ""
                self?.phoneNumberTextField.placeholder = "your phone number is not valid"
                
            }
        }, phone : self.tempPhoneNumber)
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
            
        }, code: verificationCodeTextField.text ?? "", phone: self.tempPhoneNumber , regionCode : self.tempRegionCode)
    }
    
}

