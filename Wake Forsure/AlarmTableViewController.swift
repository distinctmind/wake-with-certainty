//
//  AlarmTableViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-03.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit


class AlarmTableViewController: UITableViewController {
    
    var theSelectedIndexPath: Int?
    var cellEdited = false
    var valueIsLargest = false
    var sampleData = SampleData()
    var userTheme = UserTheme.userThemeInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name: NSNotification.Name(rawValue: "switchToggled"), object: nil)
        
        if (userTheme.getUserTheme() == "blackTheme") {
            
            self.navigationController?.navigationBar.tintColor = UIColor.white;
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            self.tableView.backgroundColor = UIColor.black
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            

            
        } else if (userTheme.getUserTheme() == "whiteTheme") {
            self.navigationController?.navigationBar.tintColor = UIColor.black;
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.tableView.backgroundColor = UIColor.white
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default

            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        //tableView.backgroundColor = UIColor.black
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.black;  // optional
        self.tableView.separatorStyle = .none
        
        
        
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        sampleData = SampleData()
        var alarmsData = sampleData.getArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToAlarmTableViewController(segue:UIStoryboardSegue) {
    }
    
    
    @IBAction func saveAlarmDetail(segue:UIStoryboardSegue) {
        
        //This will be used as the index to add the alarm to the array, chronologically!
        var insertAt = Int()
       
        if let makeAlarmTableViewController = segue.source as? MakeAlarmTableViewController {
            
            //Add the new alarm to the array
            if let alarm = makeAlarmTableViewController.alarm {
                
                //If the user clicked on the cell
                if (cellEdited) {
                    
                    cellEdited = false
                    alarmsData.remove(at: theSelectedIndexPath!)
                    
                    insertAt = getAlarmOrder(alarmDate: alarm.alarmDate!)
                    
                    //The alarm we are appending is the latest, hence goes in the end of array
                    if valueIsLargest {
                        alarmsData.append(alarm)
                    } else {
                        alarmsData.insert(alarm, at: insertAt)
                    }
                    //Update table view.
                    tableView.reloadData()
                
                //If the user just clicked the plus button
                } else {
                    
                    insertAt = getAlarmOrder(alarmDate: alarm.alarmDate!)
                    
                    //We only want to append if array is empty or value is not yet in array
                    if valueIsLargest || alarmsData.count == 0 {
                        alarmsData.append(alarm)
                    } else {
                        alarmsData.insert(alarm, at: insertAt)
                    }
                    tableView.reloadData()
                }
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualAlarms", for: indexPath) as! IndividualAlarmsTableViewCell
        var alarmStateOn = cell.switchAlarmState.isOn
        //If the switch is On
        if (alarmStateOn) {
            switchColor(itsOn: alarmStateOn, theCell: cell)
        } else {
            switchColor(itsOn: alarmStateOn, theCell: cell)
        }
        
        
        // Configure the cell...
        let alarm = alarmsData[indexPath.row] as Alarm
        cell.alarmName.text = alarm.alarmName
        cell.alarmTime.text = alarm.alarmTime
        cell.timeUntilAlarm.text = alarm.timeUntilAlarm
        cell.setEditing(true, animated: true)
        return cell
    }
    
    //Switch color of the cell
    func switchColor(itsOn: Bool, theCell: IndividualAlarmsTableViewCell) {
        
        //Currently two themes.
        if (userTheme.getUserTheme() == "blackTheme") {
            
            //If the alarm is ON
            if (itsOn) {
                //Color is black on green
                theCell.alarmName.textColor = UIColor.white
                theCell.alarmTime.textColor = UIColor.white
                theCell.timeUntilAlarm.textColor = UIColor.white
                theCell.contentView.backgroundColor = UIColor(red:0.17, green:0.75, blue:0.16, alpha:0.8)
            
            //If the alarm is OFF
            } else {
                //Color is white on black
                theCell.alarmName.textColor = UIColor.white
                theCell.alarmTime.textColor = UIColor.white
                theCell.timeUntilAlarm.textColor = UIColor.white
                theCell.contentView.backgroundColor = UIColor.black
            }
        } else {
            //If the alarm is ON
            if (itsOn) {
                //Color is black on green
                theCell.alarmName.textColor = UIColor.black
                theCell.alarmTime.textColor = UIColor.black
                theCell.timeUntilAlarm.textColor = UIColor.black
                theCell.contentView.backgroundColor = UIColor(red:0.17, green:0.75, blue:0.16, alpha:0.8)
                
                //If the alarm is OFF
            } else {
                //Color is white on black
                theCell.alarmName.textColor = UIColor.black
                theCell.alarmTime.textColor = UIColor.black
                theCell.timeUntilAlarm.textColor = UIColor.black
                theCell.contentView.backgroundColor = UIColor.white
            }
        }
    }
    
    func shouldReload() {
        self.tableView.reloadData()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if (!cellEdited) {
            performSegue(withIdentifier: "buttonToShowMakeAlarm", sender: nil)
        }
    }
    
    func getAlarmOrder(alarmDate: Date) -> Int {
        var counter = 0
        valueIsLargest = false
        for eachAlarmDate in alarmsData {
            
            if alarmDate.compare(eachAlarmDate.alarmDate!) == ComparisonResult.orderedSame {
                return counter
            } else if alarmDate.compare(eachAlarmDate.alarmDate!) == ComparisonResult.orderedDescending {
                counter += 1
                continue
            } else if alarmDate.compare(eachAlarmDate.alarmDate!) == ComparisonResult.orderedAscending {
                return counter
            }
            counter += 1
        }
        valueIsLargest = true
        return counter
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            alarmsData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        theSelectedIndexPath = indexPath.row
        cellEdited = true
        performSegue(withIdentifier: "showAlarmMaking", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (userTheme.getUserTheme() == "whiteTheme") {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.black
        }
        
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAlarmMaking" {
            
            let vc = segue.destination as! MakeAlarmTableViewController
            vc.theIndexPathRow = theSelectedIndexPath
            vc.editingCell = true
            vc.alarmArray = alarmsData
        } else if segue.identifier == "buttonToShowMakeAlarm" {
            
        }
    }
    

}
