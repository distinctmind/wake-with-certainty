//
//  IndividualAlarmsTableViewCell.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-03.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit

class IndividualAlarmsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var timeUntilAlarm: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var switchAlarmState: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchToggle(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switchToggled"), object: nil)
    }
    
    

}
