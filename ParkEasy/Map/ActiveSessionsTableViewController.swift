//
//  ActiveSessionsTableViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/24/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them

class ActiveSessionsTableViewController: UITableViewController {
        
    var sessions: [Session]?
    let formatter = DateFormatter()
    
    let storageManger = StorageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchActiveSessions()
    }

    func fetchActiveSessions() {
        
        sessions = storageManger.fetchActiveSessions()
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return sessions != nil ? sessions!.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSessionCell", for: indexPath) as! ActiveSessionTableViewCell
        
        let session = sessions![indexPath.row]
        
        cell.locationLabel.text = "Location name: " + session.locationName
        
        cell.vehicleLabel.text = "License plate: \(session.vehicleLicensePlate)"
        
        cell.session = session

        cell.currentPriceLabel.text = "Current cost: £\(Double((round(Date().timeIntervalSince(session.startTime) * (2/3600) * 100)) / 100))"
        
        if let endTime = session.endTime {
            
            cell.timeLabel.text = "Time remaining: " + formattedCountdown(interval: Date().timeIntervalSince(endTime))
        }
        
        else {
            
            cell.timeLabel.text = "Time running: " + formattedCountdown(interval: session.startTime.timeIntervalSince(Date()))
        }
        
        cell.stopSessionAction = { [weak self] (session: Session?) -> Void in
            
            self?.storageManger.updateSession(licensePlate: session!.vehicleLicensePlate, endTime: Date())
            cell.stopButton.setTitle("Session stopped", for: .normal)
            cell.stopButton.backgroundColor = UIColor.gray
            cell.stopButton.isEnabled = false
            self?.tableView.reloadData()
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    func formattedCountdown(interval: TimeInterval) -> String {
        
        let hours: Int = Int(interval/3600)
        let minutes: Int = Int(interval/60) % 60
        
        return "\(abs(hours))HR \(abs(minutes))M"
    }
}
