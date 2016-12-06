//
//  Alarm.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-05.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit

struct Alarm {
    
    var alarmName: String?
    var timeUntilAlarm: String?
    var alarmTime: String?
    
    init(alarmName: String?, timeUntilAlarm: String?, alarmTime: String?) {
        self.alarmName = alarmName
        self.timeUntilAlarm = timeUntilAlarm
        self.alarmTime = alarmTime
    }
}
