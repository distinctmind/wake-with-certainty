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
    
    var alarmArray = [Alarm]()

    var theIndexPathRow: Int?
    var editingCell = false
    var userTheme = UserTheme.userThemeInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var touchScreen = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        touchScreen.numberOfTapsRequired = 1
        view.addGestureRecognizer(touchScreen)
        
        if (userTheme.getUserTheme() == "blackTheme") {
            self.tableView.backgroundColor = UIColor.black
        } else {
            self.tableView.backgroundColor = UIColor.white
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.estimatedRowHeight = 650.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if (userTheme.getUserTheme() == "blackTheme") {
            
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
            self.navigationController?.navigationBar.tintColor = UIColor.white;
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
            alarmNameTextField.backgroundColor = UIColor.black
            alarmNameTextField.textColor = UIColor.white
            alarmNameTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            
            alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
            alarmTimePicker.backgroundColor = UIColor.black
            
            timeUntilAlarmLabel.backgroundColor = UIColor.black
            timeUntilAlarmLabel.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            
        } else {
            
            self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent;
            self.navigationController?.navigationBar.tintColor = UIColor.black;
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            
            alarmNameTextField.backgroundColor = UIColor.white
            alarmNameTextField.textColor = UIColor.black
            alarmNameTextField.setValue(UIColor.gray, forKeyPath: "_placeholderLabel.textColor")
            
            alarmTimePicker.setValue(UIColor.black, forKey: "textColor")
            alarmTimePicker.backgroundColor = UIColor.white
            
            timeUntilAlarmLabel.backgroundColor = UIColor.white
            timeUntilAlarmLabel.textColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        
        if editingCell == true {
            alarmTimePicker.date = alarmArray[(theIndexPathRow)!].alarmDate!
            alarmNameTextField.text = alarmArray[(theIndexPathRow)!].alarmName
        }
        timeUntilAlarmLabel.text = timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (userTheme.getUserTheme() == "blackTheme") {
            cell.contentView.backgroundColor = UIColor.black
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SaveAlarmDetail" {
            
            alarmNameTextField.resignFirstResponder()
            
            
            if (alarmNameTextField.text == "") {
                alarmNameTextField.text = "Alarm"
            }
            alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date)
        
        }         
        
        
    }
    
    func convertStringToText(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.date(from: string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alarmNameTextField.resignFirstResponder()
        return alarmNameTextField.isFirstResponder;
    }
    
    func handleTap(sender: UISwipeGestureRecognizer) {
        
        if (sender.state == .ended) {
            alarmNameTextField.resignFirstResponder()
        }
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
