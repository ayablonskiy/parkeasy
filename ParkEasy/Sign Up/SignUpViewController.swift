//
//  SignUpViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/20/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import PhoneNumberKit //Phone number validation library installed via CocoaPods


class SignUpViewController: UIViewController {
    
    //Reference to text field in view
    @IBOutlet weak var textInputView: PhoneNumberTextField!
    
    var formattedPhoneNumber: String?
    
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //Event triggered when user taps confirm button
    @IBAction func didPressConfirm(_ sender: Any) {
        
        if phoneNumberIsValid() {
            
            print("CALLED")
            self.performSegue(withIdentifier: "Verification", sender: self)
            
        }
        
        else {
            
           presentWarningAlert()
            
        }
        
        
    }
    func phoneNumberIsValid() -> Bool {
        
        
        do {
            
            let phoneNumberCustomDefaultRegion = try
                phoneNumberKit.parse(textInputView.text ?? "", withRegion: "GB", ignoreType: true)
            
            self.formattedPhoneNumber = phoneNumberCustomDefaultRegion.numberString
            
            return true
        }
            
        catch {
            return false
        }
    }
    
    func presentWarningAlert() {
        
        //Initialize new alert with title, message and style
        let alert = UIAlertController(title: "Please Try Again", message: "Please Enter a valid phone number", preferredStyle: UIAlertController.Style.alert)
    
        //Add action buttonb to alert. handler is nil because we do not need any functioanlity.
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        //Present alert to user
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? VerificationViewController {
            destination.userPhoneNumber = self.formattedPhoneNumber
        }
    }
}
