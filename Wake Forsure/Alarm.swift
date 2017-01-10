//
//  Alarm.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-05.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import AVFoundation

class Alarm: NSObject, NSCoding {
    
    var alarmName: String!
    var timeUntilAlarm: String!
    var alarmTime: String!
    var alarmDate: Date!
    var alarmSong: MPMediaItemCollection!
    var defaultAlarmSong: [String: URL]!
    
    //Initializer for when the user choses custom Song
    init(alarmName: String?, timeUntilAlarm: String?, alarmTime: String?, alarmDate: Date?, alarmSong: MPMediaItemCollection?) {
        self.alarmName = alarmName
        self.timeUntilAlarm = timeUntilAlarm
        self.alarmTime = alarmTime
        self.alarmDate = alarmDate
        self.alarmSong = alarmSong
    }
    
    //Intializer for when the user choses a default Song
    init(alarmName: String?, timeUntilAlarm: String?, alarmTime: String?, alarmDate: Date?, defaultAlarmSong: [String: URL]?) {
        self.alarmName = alarmName
        self.timeUntilAlarm = timeUntilAlarm
        self.alarmTime = alarmTime
        self.alarmDate = alarmDate
        self.defaultAlarmSong = defaultAlarmSong
    }
    
    
    //Initializer for when the user has not chosen a song yet
    init(alarmName: String?, timeUntilAlarm: String?, alarmTime: String?, alarmDate: Date?) {
        self.alarmName = alarmName
        self.timeUntilAlarm = timeUntilAlarm
        self.alarmTime = alarmTime
        self.alarmDate = alarmDate
    }
    
    override init(){}
    
    
    required init(coder decoder: NSCoder) {
        self.alarmName = decoder.decodeObject(forKey: "alarmName") as! String
        self.timeUntilAlarm = decoder.decodeObject(forKey: "timeUntilAlarm") as! String
        self.alarmTime = decoder.decodeObject(forKey: "alarmTime") as! String
        self.alarmDate = decoder.decodeObject(forKey: "alarmDate") as! Date
        self.alarmSong = decoder.decodeObject(forKey: "alarmSong") as? MPMediaItemCollection
        self.defaultAlarmSong = decoder.decodeObject(forKey: "defaultAlarmSong") as? [String: URL]
    }

    
    func encode(with aCoder: NSCoder) {
        if let alarmName = alarmName { aCoder.encode(alarmName, forKey: "alarmName") }
        if let timeUntilAlarm = timeUntilAlarm { aCoder.encode(timeUntilAlarm, forKey: "timeUntilAlarm") }
        if let alarmTime = alarmTime { aCoder.encode(alarmTime, forKey: "alarmTime") }
        if let alarmDate = alarmDate { aCoder.encode(alarmDate, forKey: "alarmDate") }
        if let alarmSong = alarmSong { aCoder.encode(alarmSong, forKey: "alarmSong") }
        if let defaultAlarmSong = defaultAlarmSong { aCoder.encode(defaultAlarmSong, forKey: "defaultAlarmSong") }

    }
    
    func timeUntilAlarm(userDate: TimeInterval) -> String {
        var timeUntilAlarmGoesOff = ""
        
        //One day forward
        if (userDate < 0) {
            timeUntilAlarmGoesOff = convertTime(userTime: userDate, forwards: false)
        } else if (userDate > 0 && userDate < 60) {
            
            timeUntilAlarmGoesOff = "0h 1m"
            
        } else if (userDate >= 60 && userDate < 3600) {
            if (lround(userDate/60)==60) {
                timeUntilAlarmGoesOff = "1h 0m"
            } else {
                timeUntilAlarmGoesOff = "0h " + String(lround(userDate/60)) + "m"
            }
        } else if(userDate >= 3600) {
            timeUntilAlarmGoesOff = convertTime(userTime: userDate, forwards: true)
        }
        
        return timeUntilAlarmGoesOff
    }
    
    func convertTime(userTime: Double, forwards: Bool) -> String {
        
        var numberOfSeconds = 86400.0;
        var timeUntilAlarmGoesOff = 0.0
        var finalString = ""
        
        //Seconds are positive
        if (forwards) {
            timeUntilAlarmGoesOff = userTime
            
            //Seconds are negative - going back.
        } else {
            timeUntilAlarmGoesOff = numberOfSeconds + userTime
        }
        
        //Number of hours
        timeUntilAlarmGoesOff = timeUntilAlarmGoesOff / (3600)
        
        // ** Next step is to convert decimal time to normal time **
        
        //If Number of hours is a perfect number that has 0 minutes
        if (timeUntilAlarmGoesOff.truncatingRemainder(dividingBy: 3600.0) == 0) {
            let hour = String(timeUntilAlarmGoesOff / 3600)
            finalString = hour + "h 0m"
            //If not we have to split the hour and the minute part and convert
        } else {
            
            var hourAndMinute = String(timeUntilAlarmGoesOff).components(separatedBy: ".")
            var hour = hourAndMinute[0]
            
            finalString = hour + "h"
            var minute = hourAndMinute[1]
            
            minute = "0" + "." + minute
            
            //If the new string minute when converted to a double is actually a Double then convert to minute
            if let aMinute = Double(minute) {
                
                if (lround(aMinute*60) == 60) {
                    var tempHour = Int(hour)
                    tempHour = tempHour!+1
                    hour = String(tempHour!)
                    finalString = hour + "h" + " 0m"
                } else {
                    finalString += " \(lround(aMinute*60))m"
                }
                
            }
            
        }
        return finalString
    }
    
    
    //Previous method using AVAsset. However using a dictionary with song title and its respective URL was much easier.
    
    /*
    func getAlarmSongTitle(theSongUrl: URL) -> String {
        
        var asset = AVURLAsset(url: theSongUrl, options: nil)
        var alarmSongTitle: String? = nil
        
        for format: String in asset.availableMetadataFormats {
            for item: AVMetadataItem in asset.metadata(forFormat: format) {
                if (item.commonKey == "title") {
                    //alarmSongTitle = UIImage(data: item.value.copy(withZone: nil))!
                    print("Doing the meta data stuff")
                    alarmSongTitle = item.value?.copy(with: nil) as! String?
                    print(alarmSongTitle ?? "not working" )
                    return alarmSongTitle!
                }
            }
        }
        return alarmSongTitle!
    }
    */
    
}
