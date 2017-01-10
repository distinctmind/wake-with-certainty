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
    //let defaults = UserDefaults.standard
    var userSwitchStates = UserSwitchStates()
    var userSwitchesStatesData = [Bool]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchAlarmState.onTintColor = UIColor(red:0.05, green:0.43, blue:0.05, alpha:1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        
        var numId = sender.tag
        userSwitchesStatesData = userSwitchStates.getArray()
        userSwitchesStatesData[numId] = sender.isOn
        userSwitchStates.setArray(theArray: userSwitchesStatesData)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switchToggled"), object: numId)
    }
    
    

}
