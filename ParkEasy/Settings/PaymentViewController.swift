//
//  PaymentViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/28/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet var securityCodeLabel: UITextField!
    @IBOutlet var expiryDateLabel: UITextField!
    @IBOutlet var cardholderNameLabel: UITextField!
    @IBOutlet var cardNumberLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardholderNameLabel.delegate = self
        cardNumberLabel.delegate = self
        expiryDateLabel.delegate = self
        securityCodeLabel.delegate = self
        showCardDetails()
        
    }
    
    func areDetailsValid() -> Bool {
        
        if
            let text = cardholderNameLabel.text, text.count > 2,
            let cardNumber = cardNumberLabel.text, cardNumber.count == 16,
            let expiryDate = expiryDateLabel.text, expiryDate.count == 5,
            let securityCode = securityCodeLabel.text, securityCode.count == 3
        {
            return true
        }
        return false
        
        
    }
    func showCardDetails(){
        
        
        let storage = StorageManager()
        
        guard let card = storage.fetchCardDetails() else {
            return
        }
        
        cardholderNameLabel.text = card.cardHolderName
        cardNumberLabel.text = card.cardNumber == 0 ? "" : String(card.cardNumber)
        expiryDateLabel.text =  card.expiryDate == 0 ? "" : String(card.expiryDate)
        securityCodeLabel.text = card.securityCOde == 0 ? "" : String(card.securityCOde)
        
    }
    @IBAction func didPressConfirm(_ sender: Any) {
        
        let card = CardDetails()
        card.cardHolderName = cardholderNameLabel.text ?? ""
        card.cardNumber = Int (cardNumberLabel.text ?? "0") ?? 0
        card.expiryDate = Int (expiryDateLabel.text?.replacingOccurrences(of: "/", with: "") ?? "0") ?? 0
        card.securityCOde = Int (securityCodeLabel.text ?? "0") ?? 0
        
        let storage = StorageManager()
        storage.saveCardDetails(card: card)
        
        if areDetailsValid(){
        
            self.navigationController?.popViewController(animated: true)
        }
        
        else {
            
            let alert = UIAlertController(title: "Warning", message: "Invalid card details. Please amend.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
extension PaymentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            
            return shouldChangeCharacter(textField, shouldChangeCharactersIn: range, replacementString: string, limit: 16)
            
        case 2:
            
//            var originalText = textField.text
//
//            if let text = originalText, text.count > string.count {
//
//
//            }
//
//            else {
//
//                if range.location == 2 {
//
//                    originalText?.append("/")
//                    textField.text = originalText
//                }
//            }
            
            return shouldChangeCharacter(textField, shouldChangeCharactersIn: range, replacementString: string, limit: 5)
            
        case 3:
        
            return shouldChangeCharacter(textField, shouldChangeCharactersIn: range, replacementString: string, limit: 3)
            
            default:
                
                break
            
        }
        
        return true
    }
    
    func shouldChangeCharacter(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, limit: Int) -> Bool {
        
        //Limit text field characters to 4 maximum
        guard let text = textField.text else { return true }
        
        let count = text.count + string.count - range.length
        
        return count <= limit
    }
}
