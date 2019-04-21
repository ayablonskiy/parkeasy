//
//  ActiveSessionTableViewCell.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/24/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit //Apple UI framework / library used for displaying UI elements and interacting with them

class ActiveSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    var stopSessionAction: ((Session?) -> Void)?
    var session: Session?
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        
        stopSessionAction?(session)
    }
    
}
