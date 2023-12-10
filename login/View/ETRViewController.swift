//
//  ETRViewController.swift
//  login
//
//  Created by yalda saeedi on 9/18/1402 AP.
//

import Foundation
import UIKit
import NotificationBannerSwift

class ETRViewController : UIViewController {
    
    @IBOutlet weak var originLatTF: UITextField!
    @IBOutlet weak var originLngTF: UITextField!
    @IBOutlet weak var destinationLatTF: UITextField!
    @IBOutlet weak var destinationLngTF: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.originLatTF.placeholder = "لطفا عرض جغرافیایی مبدا را وارد کنید"
        self.originLngTF.placeholder =  "لطفا طول جغرافیایی مبدا را وارد کنید"
        self.destinationLatTF.placeholder = "لطفا عرض جغرافیایی مقصد را وارد کنید"
        self.destinationLngTF.placeholder = "لطفا طول جغرافیایی مقصد را وارد کنید"
        
        self.setupTextFields()
        
    }
    
    @IBAction func callingETA(_ sender: Any) {
        guard let originLat = self.originLatTF.text else{
            
            print("originLat is empty")
            return
        }
        guard let originLng = self.originLngTF.text else{
            
            print("originLng is empty")
            return
        }
        guard let destinationLat = self.destinationLatTF.text else{
            
            print("destinationLat is empty")
            return
        }
        guard let destinationLng = self.destinationLngTF.text else{
            
            print("destinationLng is empty")
            return
        }
        APICaller.shared.ETARequest(completionHandler: { result in
            
            switch result{
                
            case .success(let distance):
                DispatchQueue.main.async{
                    let distanceBanner = NotificationBanner(title: "مسافت",
                                                            subtitle: "مسافت شما برابر است با:\(distance)",
                                                            leftView: nil,
                                                            rightView: nil,
                                                            style: .success,
                                                            colors: nil)
                    distanceBanner.show()
                }
                
               
            case .failure(let error):
                DispatchQueue.main.async{
                    let errorBanner = NotificationBanner(title: "مسافت",
                                                            subtitle: "شما طول و عرض اشتباهی وارد کردید",
                                                            leftView: nil,
                                                            rightView: nil,
                                                            style: .warning,
                                                            colors: nil)
                    errorBanner.show()
                }
                print(error)
            }
            
        }, originLat: originLat,
           originLng: originLng,
           destinationLat: destinationLat,
           destinationLng: destinationLng)
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
            
        originLatTF.inputAccessoryView = toolbar
        originLngTF.inputAccessoryView = toolbar
        destinationLatTF.inputAccessoryView = toolbar
        destinationLngTF.inputAccessoryView = toolbar
    }
        
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
