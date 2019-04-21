//
//  settingsViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 2/26/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class settingsViewController: UITableViewController{

    @IBOutlet var paymentMethodLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var fistNameLabel: UILabel!
    
    var dataType: userDetailDataType?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserDetails()
        fetchCardDetails()
    }
    
    func fetchUserDetails() {
        
        let storageManager = StorageManager()
        let user = storageManager.fetchUserDetails()
        
        self.phoneNumberLabel.text = user.phoneNumber
        self.fistNameLabel.text = user.firstName
        self.lastNameLabel.text = user.lastName
    }
    
    func fetchCardDetails() {
        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? UserDetailViewController {
            
            detailVC.dataType = self.dataType
        }
    }
}

extension settingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            
            self.dataType = userDetailDataType(dataType: .firstName)
            
            self.performSegue(withIdentifier: "ToTextInput", sender: self)
            
        case 1:
            
            self.dataType = userDetailDataType(dataType: .lastName)
            
            self.performSegue(withIdentifier: "ToTextInput", sender: self)
            
        case 2:
            
            self.dataType = userDetailDataType(dataType: .phoneNumber)
            
            self.performSegue(withIdentifier: "ToTextInput", sender: self)
            
        default: break
        }
    }
}


