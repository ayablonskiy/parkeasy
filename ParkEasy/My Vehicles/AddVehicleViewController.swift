//
//  AddVehicleViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/14/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them

class AddVehicleViewController: UIViewController {
    @IBOutlet weak var licensePlateTextField: UITextField!
    
    @IBOutlet weak var carModelTextField: UITextField!
   
    @IBOutlet weak var carMakerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func addButtonPresed(_ sender: Any) {
        
        let storageManager = StorageManager()
        
        let vehicle  = Vehicle()
        vehicle.licensePlate = licensePlateTextField.text!
        vehicle.vehicleModel = carModelTextField.text!
        vehicle.carMaker = carMakerTextField.text!
        
        storageManager.saveVehicle(vehicle: vehicle)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func licensePlateIsValid() -> Bool {

        if let text = licensePlateTextField.text, text .count > 2, text.count < 9 {
            
            return true
            
        }
            
        else {
            return false
        }
    
    }
    
    func carModelIsValid() -> Bool {
        
        if let text = carModelTextField.text, text.count > 2 {
            return true
        }
        else {
            return false
        }
    }
    
    func carMakerIsValid() -> Bool {
        
        if let text = carMakerTextField.text, text.count > 2
        {
            
            return true
        }
        
        else {
            return false
        }
    }
}
    

