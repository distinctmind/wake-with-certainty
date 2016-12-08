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
    var alarmDate: Date?
    
    init(alarmName: String?, timeUntilAlarm: String?, alarmTime: String?, alarmDate: Date?) {
        self.alarmName = alarmName
        self.timeUntilAlarm = timeUntilAlarm
        self.alarmTime = alarmTime
        self.alarmDate = alarmDate
    }
}
