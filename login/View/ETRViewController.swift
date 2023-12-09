//
//  ETRViewController.swift
//  login
//
//  Created by yalda saeedi on 9/18/1402 AP.
//

import Foundation
import UIKit

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
    }
    @IBAction func callingETA(_ sender: Any) {
        APICaller.shared.ETARequest()
    }
}
