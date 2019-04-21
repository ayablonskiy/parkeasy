//
//  UserDetailViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/12/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit
import PhoneNumberKit

struct userDetailDataType {
    
    var dataType: DataType
    enum DataType {
        case firstName
        case lastName
        case phoneNumber
    }
}

class UserDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var formattedPhoneNumber: String?
    
    var dataType: userDetailDataType?
    
    let phoneNumberKit = PhoneNumberKit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillTextField()
        
    }
    func fillTextField() {
        
        guard let dataType = dataType else {
            
            return
        }
        
        let storageManager = StorageManager()
        let user = storageManager.fetchUserDetails()
        
        switch dataType.dataType {
            
        case .firstName:
            
            self.title = "Edit first name"
            self.textField.text = user.firstName
            
        case .lastName:
            
            self.title = "Edit last name"
            self.textField.text = user.lastName
            
        case .phoneNumber:
            
            self.title = "Edit phone numebr"
            self.textField.text = user.phoneNumber
        }
    }

    @IBAction func didPressConfirm(_ sender: Any) {
        
        if isTextValid() {
            
            let storageManager = StorageManager()
            let user = storageManager.fetchUserDetails()
            
            guard let dataType = dataType else {
                
                return
            }
            
            switch dataType.dataType {
                
            case .firstName:
                
                storageManager.saveUserDetails(firstName: textField.text!, lastName: user.lastName, phoneNumber: user.phoneNumber)
                
            case .lastName:
                
                storageManager.saveUserDetails(firstName: user.firstName, lastName: textField.text!, phoneNumber: user.phoneNumber)
                
            case .phoneNumber:
                
                storageManager.saveUserDetails(firstName: user.firstName, lastName: user.lastName, phoneNumber: formattedPhoneNumber!)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
 
    
    func isTextValid() -> Bool {
        
        guard let dataType = dataType else {
            
            return false
        }
        
        switch dataType.dataType {
            
        case .firstName, .lastName:
            
            if let count = textField.text?.count, count > 1 {
                
                return true
            }
            
            
            break
            
        case .phoneNumber:
            
            if phoneNumberIsValid() {
                
                return true
                
            }
        }
        
        return false
    }
    
    func phoneNumberIsValid() -> Bool {
        
        
        do {
            
            let phoneNumberCustomDefaultRegion = try
                phoneNumberKit.parse(textField.text ?? "", withRegion: "GB", ignoreType: true)
            
            self.formattedPhoneNumber = phoneNumberCustomDefaultRegion.numberString
            
            return true
        }
            
        catch {
            return false
        }
    }
}
