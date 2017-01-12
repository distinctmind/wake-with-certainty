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

    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var timeUntilAlarmLabel: UILabel!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmSongLabel: UILabel!
    @IBOutlet weak var alarmSongNameLabel: UILabel!
    
    
    var alarmArray = [Alarm]()

    var theIndexPathRow: Int?
    var editingCell = false
    var userChoseSong: Bool?
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
        
        //User is in a editing cell
        if (editingCell) {
            
            //User is coming from the Alarm View
            if (!userChoseSong!) {
                
                alarmTimePicker.date = alarmArray[(theIndexPathRow)!].alarmDate!
                alarmNameTextField.text = alarmArray[(theIndexPathRow)!].alarmName
                timeUntilAlarmLabel.text = alarmArray[(theIndexPathRow)!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
                
                //User has a custom song in the editing cell
                if (alarmArray[theIndexPathRow!].alarmSong != nil) {
                    
                    alarmSong = alarmArray[theIndexPathRow!].alarmSong
                    defaultAlarmSong = nil
                    alarmSongNameLabel.text = alarmArray[theIndexPathRow!].alarmSong.items[0].title!
                    
               //User has a default song in the editing cell
                } else {
                    defaultAlarmSong = alarmArray[theIndexPathRow!].defaultAlarmSong
                    alarmSong = nil
                    alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[theIndexPathRow!].defaultAlarmSong)
                }
                
            //User coming from Add Song View
            } else {
                
                if (alarmArray[theIndexPathRow!].alarmSong != nil) {
                    
                    alarmSong = alarmArray[theIndexPathRow!].alarmSong
                    defaultAlarmSong = nil
                    alarmSongNameLabel.text = alarmArray[theIndexPathRow!].alarmSong.items[0].title!
                    
                } else {
                    
                    defaultAlarmSong = alarmArray[theIndexPathRow!].defaultAlarmSong
                    alarmSong = nil
                    alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[theIndexPathRow!].defaultAlarmSong)
                    
                }
                timeUntilAlarmLabel.text = alarmArray[theIndexPathRow!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            }
        
        // User is in a new cell
        } else {
            
            //User is coming from Alarm View
            if (!userChoseSong!) {
                
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date)
                alarmArray.append(alarm!)
                timeUntilAlarmLabel.text = alarmArray[alarmArray.count-1].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
                alarmSongNameLabel.text = "Choose Song"
            
            //User is coming from Add Song View
            } else {
                
                if (alarmArray[alarmArray.count-1].alarmSong != nil) {
                    alarmSong = alarmArray[alarmArray.count-1].alarmSong
                    defaultAlarmSong = nil
                    alarmSongNameLabel.text = alarmArray[alarmArray.count-1].alarmSong.items[0].title!
                } else {
                    defaultAlarmSong = alarmArray[alarmArray.count-1].defaultAlarmSong
                    alarmSong = nil
                    alarmSongNameLabel.text = getDefaultSongTitle(theDefaultSongDict: alarmArray[alarmArray.count-1].defaultAlarmSong)
                }
                
                timeUntilAlarmLabel.text = alarmArray[alarmArray.count-1].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
            }
        }
        
    }
    
    func getDefaultSongTitle(theDefaultSongDict: [String: URL]) -> String {
        
        for key in theDefaultSongDict.keys {
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
                defaultAlarmSong = nil
                
                //User is in a editing cell
                if (theIndexPathRow != nil) {
                    
                    alarmArray[theIndexPathRow!].alarmSong = alarmSong!
                    
                    //If there is a default song already there, set it to nil
                    if (alarmArray[theIndexPathRow!].defaultAlarmSong != nil) {
                        alarmArray[theIndexPathRow!].defaultAlarmSong = nil
                    }
                    
                //User is is in a new cell
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
                alarmSong = nil
                
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
        
        
        //User clicked the "Done" Button
        if segue.identifier == "SaveAlarmDetail" {
            
            //Close keyboard
            alarmNameTextField.resignFirstResponder()
            
            //If User chose no alarm name
            if (alarmNameTextField.text == "" || alarmNameTextField.text == nil) {
                alarmNameTextField.text = "Alarm"
            }
            
            //User chose a custom song
            if (alarmSong != nil) {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, alarmSong: alarmSong)
            
            //User chose a default song
            } else if (defaultAlarmSong != nil) {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, defaultAlarmSong: defaultAlarmSong)
            
            //User didn't chose any song
            } else {
                alarm = Alarm(alarmName: alarmNameTextField?.text,timeUntilAlarm: timeUntilAlarmLabel?.text, alarmTime: getAlarmTime(alarmTime: alarmTimePicker.date), alarmDate: alarmTimePicker.date, defaultAlarmSong: ["Respiration": URL(fileURLWithPath: Bundle.main.path(forResource: "Respiration", ofType: "mp3")!)])
            }
            
        //User clicked on the "Choose Song" cell
        } else if (segue.identifier == "showSongs") {
            
            let controller = segue.destination as! AddSongTableViewController
            
            controller.editingCell = editingCell
            
            controller.cellIndexPath = theIndexPathRow
            
            //User already has a custom song
            if (alarmSong != nil) {
                controller.songAlreadyChosen = alarmSong
            
            //User already has a default song
            } else if (defaultAlarmSong != nil) {
                controller.defaultSongAlreadyChosen = defaultAlarmSong
            
            //User didn't choose any songs yet
            } else {
                controller.selectedSongInfo = ["9":9]
                defaults.set(controller.selectedSongInfo, forKey: "selectedSongInfo")
            }
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Close keyboard if user clicks on anywhere on first cell
        if (indexPath.row == 0 && indexPath.section == 0) {
            alarmNameTextField.resignFirstResponder()
        
        //Makes sure that user clicked on "Choose Song" cell
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

    
    @IBAction func alarmTimeAction(_ sender: Any) {
        
        /*
        if (editingCell) {
            timeUntilAlarmLabel.text = alarmArray[(theIndexPathRow)!].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        } else {
            timeUntilAlarmLabel.text = alarmArray[0].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        }
        */
        
        timeUntilAlarmLabel.text = alarmArray[0].timeUntilAlarm(userDate: alarmTimePicker.date.timeIntervalSinceNow)
        
    }
    
    func getAlarmTime(alarmTime: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: alarmTime as Date)
        
        
    }
    
    func getTime(alarmDate: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let theStringDate = dateFormatter.string(from: alarmDate)
        
        let theNewDate = convertStringToText(string: theStringDate)!
        
        return theNewDate

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
