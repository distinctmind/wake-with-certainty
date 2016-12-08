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
    var alarmsData = [Alarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        tableView.allowsSelection = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name: NSNotification.Name(rawValue: "switchToggled"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            self.performSegue(withIdentifier: "showTime", sender: nil)
        }
    }
    
    @IBAction func cancelToAlarmTableViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveAlarmDetail(segue:UIStoryboardSegue) {
        
        if let makeAlarmTableViewController = segue.source as? MakeAlarmTableViewController {
            
            //add the new alarm to the alarm array
            if let alarm = makeAlarmTableViewController.alarm {
                
                if (cellEdited) {
                    cellEdited = false
                    alarmsData[theSelectedIndexPath!] = alarm
                    tableView.reloadData()
                    
                } else {
                    alarmsData.append(alarm)
                    let indexPath = NSIndexPath(row: alarmsData.count-1, section: 0)
                    tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
                    //update the tableView
                }
                
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarmsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualAlarms", for: indexPath) as! IndividualAlarmsTableViewCell
        print("switch state is not reached yet")
        
        if (cell.switchAlarmState.isOn) {
            print("switch state is good")
            cell.contentView.backgroundColor = UIColor.green
            print("color is set good")
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        
        /*
        if let theSwitch = IndividualAlarmsTableViewCell.switchAlarmState as? UISwitch {
            
        }
         */
        
        // Configure the cell...
        
        let alarm = alarmsData[indexPath.row] as Alarm
        cell.alarmName.text = alarm.alarmName
        cell.alarmTime.text = alarm.alarmTime
        cell.timeUntilAlarm.text = alarm.timeUntilAlarm
        cell.setEditing(true, animated: true)
        return cell
    }
    
    func shouldReload() {
        self.tableView.reloadData()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if (!cellEdited) {
            performSegue(withIdentifier: "buttonToShowMakeAlarm", sender: nil)
        }
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
            
            let vc = segue.destination as! UINavigationController
            let tc = vc.topViewController as! MakeAlarmTableViewController
            tc.theIndexPathRow = theSelectedIndexPath
            tc.editingCell = true
            tc.alarmArray = alarmsData
        } else if segue.identifier == "buttonToShowMakeAlarm" {
            
        }
    }
    

}
