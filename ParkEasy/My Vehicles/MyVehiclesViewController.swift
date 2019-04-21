//
//  MyVehiclesViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/12/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them

class MyVehiclesViewController: UIViewController {

    enum Mode {
        case selection
        case normal
        
    }
    
    var mode: Mode = .normal
    
    var onDismiss = { }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    var vehicles: [Vehicle]?
    var selectedVehicle: Vehicle?
    
    let storageManager = StorageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        onDismiss()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadVehicleData()
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func loadVehicleData() {
        
        vehicles = storageManager.fetchMyVehicles()
        
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            
        }
    
        else {
            
            tableView.setEditing(true, animated: true)
        }
    }
    
}

extension MyVehiclesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vehicles?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell")
        
        let vehicle = vehicles![indexPath.row]
        
        cell?.textLabel?.text = vehicle.licensePlate
        cell?.detailTextLabel?.text = "\(vehicle.vehicleModel), \(vehicle.carMaker)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 63
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        
        case.delete:
            
            storageManager.deleteVehicle(vehicle: vehicles![indexPath.row])
            
            vehicles?.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        default:
            
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mode == .selection {
            
            let vehicle = vehicles?[indexPath.row]
            
            self.selectedVehicle = vehicle
            
            onDismiss()
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? BookingViewController {
        
        vc.selectedVehicle = self.selectedVehicle
    }
  }
}
