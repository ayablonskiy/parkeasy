//
//  BookingDurationTableViewCell.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/20/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class BookingDurationTableViewCell: UITableViewCell {

    static let identifier = "BookingDurationID"
    
    @IBOutlet var durationSlider: UISlider!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var limitlessParkingSwitch: UISwitch!
    @IBOutlet weak var setReminderLabel: UILabel!
    
    @IBOutlet var setReminderSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    
    var priceChangedAction: ((Int) -> ())?
    var endDateChangedAction: ((Date) -> ())?
    var notificationDateChangedAction: ((Date) -> ())?
    var durationChangedAction: ((Float) -> ())?
    var limitlessParkingChangedAction: ((Bool) -> ())?
    var setReminderChangedAction: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.addTarget(self, action: #selector(notificationDateValueChanged(sender:)), for: .valueChanged)
        durationSlider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        datePicker.minimumDate = Date()
    }
    
    
    @objc func notificationDateValueChanged(sender: AnyObject) {
        
        notificationDateChangedAction?(datePicker.date)
    }
    
    @objc func valueChanged(_ sender: UISlider) {
        
        sender.value = roundf(sender.value)
        durationLabel.text = "\(Int(sender.value)) " + "\(sender.value == 1 ? "hour" : "hours")"
        priceLabel.text = "£\(Int(sender.value * 2))"
        
        endDateChangedAction?(Date().addingTimeInterval(Double(sender.value * 3600)))
        priceChangedAction?(Int(sender.value*2))
        durationChangedAction?(sender.value)
    }
    
    
    @IBAction func switchValueChanged(sender: AnyObject) {
    
        switch limitlessParkingSwitch.isOn {
            
        case true:
            
            durationSlider.isEnabled = false
            durationLabel.textColor = UIColor.lightGray
            priceLabel.textColor = UIColor.lightGray
            setReminderSwitch.isHidden = false
            datePicker.isHidden = false
            setReminderLabel.isHidden = false
            
        case false:
            
            durationSlider.isEnabled = true
            durationLabel.textColor = UIColor.black
            priceLabel.textColor = UIColor.black
            setReminderSwitch.isHidden = true
            datePicker.isHidden = true
            setReminderLabel.isHidden = true
        }
        
        limitlessParkingChangedAction?(limitlessParkingSwitch.isOn)
    }
    
    @IBAction func reminderSwitchValueChanged(sender: AnyObject) {
        
        switch setReminderSwitch.isOn {
            
        case true:
            
            datePicker.isHidden = false
            
        case false:
            
            datePicker.isHidden = true
        }
        
        setReminderChangedAction?(setReminderSwitch.isOn)
    }
}
