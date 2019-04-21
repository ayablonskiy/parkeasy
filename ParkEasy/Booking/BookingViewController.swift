//
//  BookingViewController.swift
//  ParkEasy
//
//  Created by Yablonskiy Alexey on 3/14/19.
//  Copyright © 2019 Yablonskiy Alexey. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController {

    enum Option: Hashable {
        case vehicleSelection
        case bookingDuration
        case reminder
        
        var hashValue: Int {
            return order
        }
        
        var order: Int {
            switch self {
            case .vehicleSelection: return 0
            case .bookingDuration: return 1
            case .reminder: return 2
            }
        }
        
        static func == (lhs: Option, rhs: Option) -> Bool {
            return lhs.order == rhs.order
        }
    }
    
    var options: [Option] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options = [.vehicleSelection, .bookingDuration, .reminder]
        
    }
}

extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    }
    
    
    
}
