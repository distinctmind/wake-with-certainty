//
//  MakeAlarmTableViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-03.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class MakeAlarmTableViewController: UITableViewController {
    
    var alarm:Alarm?
    //var alarmFunctions = Alarm()

    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var timeUntilAlarmLabel: UILabel!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmSongLabel: UILabel!
    @IBOutlet weak var alarmSongNameLabel: UILabel!
    
    
    var alarmArray = [Alarm]()

    var theIndexPathRow: Int?
    var editingCell = false
    var userChoseSong = false
    var userTheme = UserTheme.userThemeInstance
    var alarmSong: MPMediaItemCollection?
    var defaultAlarmSong: [String: URL]?
    let defaults = UserDefaults.standard
    var theSongTitle = [String]()
    var arrayOfCellData = [[cellData]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //var touchScreen = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        //touchScreen.numberOfTapsRequired = 1
        //UITableViewCell.view .addGestureRecognizer(touchScreen)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updateTimeUntilAlarm), name: NSNotification.Name(rawValue: "updateTimeUntilAlarm"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.estimatedRowHeight = 650.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if (userTheme.getUserTheme() == "blackTheme") {
            
            userTheme.setBlack(theController: self)

            alarmNameTextField.backgroundColor = UIColor.black
            alarmNameTextField.textColor = UIColor.white
            alarmNameTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            
            alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
            alarmTimePicker.backgroundColor = UIColor.black
            
            alarmSongLabel.textColor = UIColor.white
            alarmSongNameLabel.textColor = UIColor.white
            
            
            timeUntilAlarmLabel.backgroundColor = UIColor.black
            timeUntilAlarmLabel.textColor = UIColor.white
            
        } else {
            
            userTheme.setWhite(theController: self)
         
            alarmNameTextField.backgroundColor = UIColor.white
            alarmNameTextField.textColor = UIColor.black
            alarmNameTextField.setValue(UIColor.gray, forKeyPath: "_placeholderLabel.textColor")
            
            alarmTimePicker.setValue(UIColor.black, forKey: "textColor")
            alarmTimePicker.backgroundColor = UIColor.white
            
            timeUntilAlarmLabel.backgroundColor = UIColor.white
            timeUntilAlarmLabel.textColor = UIColor.black
        }
        
        if (editingCell && !userChoseSong) {

            
            alarmTimePicker.date = alarmArray[(theIndexPathRow)!].alarmDate!
            alarmNameTextField.text = alarmArray[(theIndexPathRow)!].alarmName
            timeUntilAlarmLabel.text = alarmArray[(theIndexPathRow)!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            
            
            if (alarmArray[theIndexPathRow!].alarmSong != nil) {
                alarmSongNameLabel.text = alarmArray[theIndexPathRow!].alarmSong.items[0].title!
            } else {
                alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[theIndexPathRow!].defaultAlarmSong)
            }
            
        } else if (userChoseSong && !editingCell) {
            
            userChoseSong = false
            
            if (alarmArray[alarmArray.count-1].alarmSong != nil) {
                alarmSongNameLabel.text = alarmArray[alarmArray.count-1].alarmSong.items[0].title!
            } else {
                alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[alarmArray.count-1].defaultAlarmSong)
            }
            
            timeUntilAlarmLabel.text = alarmArray[alarmArray.count-1].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            
            } else if (userChoseSong && editingCell) {
            
                userChoseSong = false
            
                //alarmTimePicker.date = alarmArray[(theIndexPathRow)!].alarmDate!
                //alarmNameTextField.text = alarmArray[(theIndexPathRow)!].alarmName
                //timeUntilAlarmLabel.text = alarmArray[(theIndexPathRow)!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            
                
                //alarmTimePicker.date = alarmArray[(theIndexPathRow)!].alarmDate!
            
                if (alarmArray[theIndexPathRow!].alarmSong != nil) {
                    alarmSongNameLabel.text = alarmArray[theIndexPathRow!].alarmSong.items[0].title!
                } else {
                    alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[theIndexPathRow!].defaultAlarmSong)
                }
                timeUntilAlarmLabel.text = alarmArray[theIndexPathRow!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            } else {
            
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date)
                
                alarmArray.append(alarm!)
                
                timeUntilAlarmLabel.text = alarmArray[alarmArray.count-1].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
                alarmSongNameLabel.text = "Choose Song"
            }
        
        
    }
    
    func getDefaultSongTitle(theDefaultSongDict: [String: URL]) -> String {
        for (key, value) in theDefaultSongDict {
            print(key)
            print(value)
            return key
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (userTheme.getUserTheme() == "blackTheme") {
            cell.contentView.backgroundColor = UIColor.black
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func unwindToMakeAlarmController(segue: UIStoryboardSegue) {
    
        if let addSongTableViewController = segue.source as? AddSongTableViewController {
            
            userChoseSong = true
            addSongTableViewController.editingCell = false
            
            if (addSongTableViewController.songChosen != nil) {
                
                //User chose a custom song from iPhone Music Library
                
                alarmSong = addSongTableViewController.songChosen
                
                //Meaning user is in editing cell
                if (theIndexPathRow != nil) {
                    
                    alarmArray[theIndexPathRow!].alarmSong = alarmSong!
                    
                    //If there is a default song already there, set it to nil
                    if (alarmArray[theIndexPathRow!].defaultAlarmSong != nil) {
                        alarmArray[theIndexPathRow!].defaultAlarmSong = nil
                    }
                //Meaning user is is a new cell
                } else {
                    
                    alarmArray[alarmArray.count-1].alarmSong = alarmSong!
                    
                    if (alarmArray[alarmArray.count-1].defaultAlarmSong != nil) {
                        alarmArray[alarmArray.count-1].defaultAlarmSong = nil
                    }
                }
                
                addSongTableViewController.songChosen = nil
                
            } else if ((addSongTableViewController.defaultSongChosen) != nil) {
                
                //User chose one of the defaults songs
                
                defaultAlarmSong = addSongTableViewController.defaultSongChosen
            
                if (theIndexPathRow != nil) {
                    
                    alarmArray[theIndexPathRow!].defaultAlarmSong = defaultAlarmSong!
                    
                    if (alarmArray[theIndexPathRow!].alarmSong != nil) {
                        alarmArray[theIndexPathRow!].alarmSong = nil
                    }
                    
                } else {
                    alarmArray[alarmArray.count-1].defaultAlarmSong = defaultAlarmSong!
                    if (alarmArray[alarmArray.count-1].alarmSong != nil) {
                        alarmArray[alarmArray.count-1].alarmSong = nil
                    }
                }
                addSongTableViewController.defaultSongChosen = nil
            }            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SaveAlarmDetail" {
            
            alarmNameTextField.resignFirstResponder()
            
            if (alarmNameTextField.text == "" || alarmNameTextField.text == nil) {
                alarmNameTextField.text = "Alarm"
            }

            if (alarmSong != nil) {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, alarmSong: alarmSong)
            } else if (defaultAlarmSong != nil) {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, defaultAlarmSong: defaultAlarmSong)
            } else {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, defaultAlarmSong: ["Respiration": URL(fileURLWithPath: Bundle.main.path(forResource: "Respiration", ofType: "mp3")!)])
            }
            
        
        } else if (segue.identifier == "showSongs") {
            let controller = segue.destination as! AddSongTableViewController
            controller.editingCell = editingCell
            controller.cellIndexPath = theIndexPathRow
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            alarmNameTextField.resignFirstResponder()
        } else if (indexPath.row == 1 && indexPath.section == 0) {
          performSegue(withIdentifier: "showSongs", sender: nil)
        }
        
    }
    
    func convertStringToText(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        return dateFormatter.date(from: string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alarmNameTextField.resignFirstResponder()
        return alarmNameTextField.isFirstResponder;
    }
    
    /*
    func handleTap(sender: UISwipeGestureRecognizer) {
        
        if (sender.state == .ended) {
            alarmNameTextField.resignFirstResponder()
        }
    }
    */
    
    @IBAction func alarmTimeAction(_ sender: Any) {
        if (editingCell) {
            timeUntilAlarmLabel.text = alarmArray[(theIndexPathRow)!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        } else {
            timeUntilAlarmLabel.text = alarmArray[0].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        }
    }
    
    func getAlarmTime(alarmTime: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: alarmTime as Date)
        
        
    }
    
    func getTime(alarmDate: Date) -> Date {
        let dateFormatter = DateFormatter()
        print(alarmDate)
        dateFormatter.dateFormat = "h:mm a"
        let theStringDate = dateFormatter.string(from: alarmDate)
        print(theStringDate)
        let theNewDate = convertStringToText(string: theStringDate)!
        print(theNewDate)
        return theNewDate

    }
    
    
    /*
    func updateTimeUntilAlarm() {
        //timeUntilAlarmLabel.text = timeUntilAlarm(userDate: )
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
