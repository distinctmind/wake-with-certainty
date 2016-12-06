//
//  MakeAlarmTableViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-03.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit
import Foundation

class MakeAlarmTableViewController: UITableViewController {
    
    var alarm:Alarm?

    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var timeUntilAlarmLabel: UILabel!
    @IBOutlet weak var alarmNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SaveAlarmDetail" {
            alarmNameTextField.resignFirstResponder()
            alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date))
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alarmNameTextField.resignFirstResponder()
        return alarmNameTextField.isFirstResponder;
    }



    
    
    @IBAction func alarmTimeAction(_ sender: Any) {
        
        timeUntilAlarmLabel.text = timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        
    }
    
    func getAlarmTime(alarmTime: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: alarmTime as Date)
        
        
    }
    
    func timeUntilAlarm(userDate: TimeInterval) -> String {
        var timeUntilAlarmGoesOff = ""
        
        //One day forward
        if (userDate < 0) {
            timeUntilAlarmGoesOff = convertTime(userTime: userDate, forwards: false)
        } else if (userDate > 0 && userDate < 60) {
            
                timeUntilAlarmGoesOff = "0h 1m"
            
        } else if (userDate >= 60 && userDate < 3600) {
            timeUntilAlarmGoesOff = "0h " + String(lround(userDate/60)) + "m"
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
        
        //If not we have to split the hour and the minute part and convert
        } else {
            
            var hourAndMinute = String(timeUntilAlarmGoesOff).components(separatedBy: ".")
            let hour = hourAndMinute[0]
            
            finalString = hour + "h"
            var minute = hourAndMinute[1]
            
            minute = "0" + "." + minute
            
            //If the new string minute when converted to a double is actually a Double then convert to minute
            if let aMinute = Double(minute) {
                finalString += " \(lround(aMinute*60))m"
            }
        
        }
        return finalString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    }
