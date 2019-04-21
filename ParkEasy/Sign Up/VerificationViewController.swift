//
//  VerificationViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/24/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

    
    @IBOutlet weak var textInputView: UITextField!
    
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
   
    var userPhoneNumber: String?
    
    var generatedCode: Int?
    
    var generatedCodeString: String? {
        
        guard let code = generatedCode else {
            return nil
        }
        return "\(code)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPhoneNumberLabel.text = "Sending verificiation code to \(userPhoneNumber ?? "")"
        textInputView.delegate = self
        textInputView.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        generateVerificationCode()
        presentCodeLabelToUser()

    }
    
    func generateVerificationCode() {
        
        let min = 1000
        
        let max = 9999
        
        generatedCode = Int.random(in: min..<max)
    }


    func presentCodeLabelToUser() {
        
        guard let code = generatedCode else {
            return
        }
        
        let label = createLabelForCode(code: code)
        
        view.addSubview(label)
        
    }
    
    func createLabelForCode(code: Int) -> UILabel {
        
        let rectForLabel = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 50)
        
        
        let codeLabel = UILabel(frame: rectForLabel)
        
        codeLabel.text = "Please enter this code: \(code)"
        codeLabel.textAlignment = NSTextAlignment.center
        codeLabel.textColor = UIColor.black
        codeLabel.backgroundColor = UIColor.white
        
        return codeLabel
    }
    
    @objc func textFieldTextDidChange(_ sender: UITextField) {
        
        guard let codeString = generatedCodeString, let text = sender.text, text.count >= 4 else {
            
            return
        }
        
        if text == codeString {
            
            presentAlert(title: "Success", body: "You can now proceed to map screen") { (action) in
    
                self.createNewUser()
                
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.openMap()
            }
        }
        else {
            
            presentAlert(title: "Wrong code", body: "Please enter correct code") { (action) in
                
                self.textInputView.text = ""
            }
        }
    }
    
    func createNewUser() {
        
        guard let number = self.userPhoneNumber else {
            return
        }
        
        let storageManager = StorageManager()
        
        storageManager.saveUserDetails(firstName: "", lastName: "", phoneNumber: number)
    }
    
    func presentAlert(title: String, body: String, action: ((UIAlertAction) -> Void)?) {
        
        //Initialise new alert with title, message and style.
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        
        //Add action to alert. handler is nil because we don't need any functionality.
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: action ?? nil))
        
        //Present alert to user.
        self.present(alert, animated: true, completion: nil)
    }
}


extension VerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Limit text field characters to 4 maximum
        guard let text = textField.text else { return true }
        
        let count = text.count + string.count - range.length
        
        return count <= 4
    }
}
