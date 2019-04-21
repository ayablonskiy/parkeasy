//
//  BookingViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/14/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController {

    var onDismiss = {}
    
    enum Option: Hashable {
        case vehicleSelection
        case bookingDuration
        
        var hashValue: Int {
            return order
        }
        
        var order: Int {
            switch self {
            case .vehicleSelection: return 0
            case .bookingDuration: return 1
            }
        }
        
        static func == (lhs: Option, rhs: Option) -> Bool {
            return lhs.order == rhs.order
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    var options: [Option] = []
    
    var selectedVehicle: Vehicle?
    var endTime: Date = Date().addingTimeInterval(3600)
    var notificationDate: Date?
    var price: Int = 2
    var duration: Float = 1
    var isLimitlessParking = false
    var setReminder = false
    var longitude: Double = 0
    var latitude: Double = 0
    var locationName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        options = [.vehicleSelection, .bookingDuration]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startSession(_ sender: Any) {
        
        let storageManager = StorageManager()
        
        let sessions = storageManager.fetchActiveSessions()
        
        let isVehicleInActiveSession = sessions.contains(where: { $0.vehicleLicensePlate == self.selectedVehicle?.licensePlate })
        
        guard (isLimitlessParking && !isVehicleInActiveSession && selectedVehicle != nil) || (selectedVehicle != nil && !isVehicleInActiveSession) else {
            
            let alert = UIAlertController(title: isVehicleInActiveSession ? "Please select a different vehicle" : "Please select a vehicle", message: "Please solve issues before continuing", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let session = Session()
        
        session.longitude = longitude
        session.latitude = latitude
        session.locationName = locationName
        
        if !isLimitlessParking {
            session.endTime = self.endTime
        }
        
        session.startTime = Date()
        session.vehicleLicensePlate = self.selectedVehicle?.licensePlate ?? ""
        
        storageManager.saveSession(session: session)
        
        if let date = notificationDate {
            
            AppDelegate.scheduleLocalNotification(triggerDate: date, title: "Booking reminder", message: "For vehicle with licence plate \(selectedVehicle!.licensePlate)")
        }
        
        onDismiss()
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return options.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let option = options[indexPath.row]
        
        switch option {
            
        case .bookingDuration:
            
            return 331
            
        default:
            
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let option = options[indexPath.row]
        
        switch option {
            
        case .vehicleSelection:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVehicleID")!
            
            cell.selectionStyle = .none
            
            cell.textLabel?.text = self.selectedVehicle?.licensePlate ?? "Select Vehicle"
            
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BookingDurationTableViewCell.identifier) as! BookingDurationTableViewCell
            
//            cell.notificationDateChangedAction = { [weak self] (date: Date) -> Void in
//                
//                self?.notificationDate = date
//            }
            
            cell.endDateChangedAction = { [weak self] (date: Date) -> Void in
                
                self?.endTime = date
            }
            
            cell.priceChangedAction = { [weak self] (price: Int) -> Void in
                
                self?.price = price
            }
            
            cell.durationChangedAction = { [weak self] (time: Float) -> Void in
                
                self?.duration = time
            }
            
            cell.limitlessParkingChangedAction = { [weak self] (isOn: Bool) -> Void in
                
                self?.isLimitlessParking = isOn
            }
            
            cell.setReminderChangedAction = { [weak self] (isOn: Bool) -> Void in
                
                self?.setReminder = isOn
            }
            
            cell.notificationDateChangedAction =  { [weak self] (date: Date) -> Void in
                
                self?.notificationDate = date
            }
            
            cell.priceLabel.text = "£\(price)"
            cell.datePicker.date = self.notificationDate ?? cell.datePicker.date
            cell.durationSlider.value = self.duration
            cell.durationLabel.text = "\(Int(self.duration)) hour"
            cell.limitlessParkingSwitch.isOn = self.isLimitlessParking
            cell.setReminderSwitch.isOn = self.setReminder
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let option = options[indexPath.row]
        
        switch option {
        case .vehicleSelection:
            return indexPath
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.performSegue(withIdentifier: "ToVehicleSelection", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToVehicleSelection" {
            
            let nav = segue.destination as? UINavigationController
            
            let vc = nav?.topViewController as? MyVehiclesViewController
            
            vc?.mode = .selection
            
            vc?.onDismiss = {
                self.selectedVehicle = vc?.selectedVehicle
            }
        }
    }
}
