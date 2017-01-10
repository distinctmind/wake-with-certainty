//
//  AddSongTableViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-24.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AVKit


struct cellData {
    let cell: Int!
    let song: String!
}

class AddSongTableViewController: UITableViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var userSongsHeader: UILabel!
    @IBOutlet weak var songsHeader: UILabel!
    @IBOutlet weak var addSongButton: UIButton!
    
    var userThemes = UserTheme.userThemeInstance
    
    let mediaPicker = MPMediaPickerController(mediaTypes: .music)
    
    var songTitleData = [MPMediaItemCollection]()
    
    var songChosen: MPMediaItemCollection?
    
    var defaultSongChosen: [String: URL]?
    
    var editingCell = false
    
    var cellIndexPath: Int?
    
    var arrayOfCellData = [[cellData]]()
    
    var theDefaultSongsUrl = [
        
            URL(fileURLWithPath: Bundle.main.path(forResource: "Respiration", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "Surfin", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "With Me", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "Lovely Day", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "everytime", ofType: "mp3")!)
        
                           ]
    
    var theDefaultSongsPlayer = [AVAudioPlayer]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createSongPlayer()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        
        if let songTitlesData = defaults.object(forKey: "savedSongTitles") as? NSData {
            
            songTitleData = (NSKeyedUnarchiver.unarchiveObject(with: songTitlesData as Data) as? [MPMediaItemCollection]? ?? [MPMediaItemCollection]())!
        }
        
        arrayOfCellData = [
            
            [
            cellData(cell: 1, song: "My Songs")
            ],
            
            [
            cellData(cell: 2, song: "Songs"),
            cellData(cell: 3, song: "Respiration"),
            cellData(cell: 3, song: "Surfin"),
            cellData(cell: 3, song: "With Me"),
            cellData(cell: 3, song: "Lovely Day"),
            cellData(cell: 3, song: "everytime")
            ]
                        ]

        
        createCellDataForSongs()

        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name: NSNotification.Name(rawValue: "addSongButtonPressed"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        

        if (userThemes.getUserTheme() == "blackTheme") {
            userThemes.setBlack(theController: self)
        } else {
            userThemes.setWhite(theController: self)
        }
        
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfCellData[section].count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (arrayOfCellData[indexPath.section][indexPath.row].cell == 1) {
            
            let cell = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?[0] as! HeaderTableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.songHeaderLabel.text = arrayOfCellData[indexPath.section][indexPath.row].song
            cell.selectionStyle = .none
            setCellColor(theLabel: cell.songHeaderLabel, theCell: cell)
            return cell
            
        } else if (arrayOfCellData[indexPath.section][indexPath.row].cell == 2) {
            
            let cell = Bundle.main.loadNibNamed("Header2TableViewCell", owner: self, options: nil)?[0] as! Header2TableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "Header2TableViewCell") as! Header2TableViewCell
            cell.songHeader2Label.text = arrayOfCellData[indexPath.section][indexPath.row].song
            cell.selectionStyle = .none
            setCellColor(theLabel: cell.songHeader2Label, theCell: cell)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath)
            cell.textLabel?.text = arrayOfCellData[indexPath.section][indexPath.row].song
            setCellColor(theLabel: cell.textLabel!, theCell: cell)
            return cell
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //songChosen = arrayOfCellData[indexPath.section][indexPath.row].song
        if (indexPath.section == 0) {
            
            if (indexPath.row != 0) {
                songChosen = songTitleData[indexPath.row-1]
                performSegue(withIdentifier: "saveSong", sender: self)
            }
        } else {
            defaultSongChosen = [arrayOfCellData[1][indexPath.row].song:theDefaultSongsUrl[indexPath.row-1]]
            performSegue(withIdentifier: "saveSong", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSong" {
            
        }
    }
    
    func createSongPlayer() {
        
        for eachURL in theDefaultSongsUrl {
            
            do {
                try theDefaultSongsPlayer.append(AVAudioPlayer(contentsOf: eachURL))
            } catch {
                print("ERROR CONVERTING TO AVAUDIOPLAYER")
            }
        }
        
    }
    
    func createCellDataForSongs() {
        
        var i = arrayOfCellData[0].count
        var songTitle = ""
        
        if (i == 6) {
            songTitle = songTitleData[songTitleData.count-1].items[0].title!
            arrayOfCellData[0].remove(at: arrayOfCellData[0].count-1)
            arrayOfCellData[0].append(cellData(cell: 3, song: songTitle))
        }
        
        for songMediaItem in songTitleData[i-1 ..< songTitleData.endIndex] {
            
            songTitle = songMediaItem.items[0].title!
            
            if (i < 6) {
                arrayOfCellData[0].append(cellData(cell: 3, song: songTitle))
            }
            i = i + 1
        }
        
    }
    
    func setCellColor(theLabel: UILabel, theCell: UITableViewCell) {
        
        if (userThemes.getUserTheme() == "blackTheme") {
            theLabel.textColor = UIColor.white
            theCell.contentView.backgroundColor = UIColor.black
            theCell.backgroundView?.backgroundColor = UIColor.black
            theCell.backgroundColor = UIColor.black
        } else {
            theLabel.textColor = UIColor.black
            theCell.contentView.backgroundColor = UIColor.white
            theCell.backgroundView?.backgroundColor = UIColor.white
        }
    }
    

    func shouldReload() {
        if (userThemes.getUserTheme() == "blackTheme") {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        present(mediaPicker, animated: true, completion: {})
    }
    

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        if (mediaItemCollection.count == 1) {
            mediaPicker.dismiss(animated: true, completion: {})
        }
        
        let isSongUnique = isSongAlreadyChosen(theCollection: mediaItemCollection)
        
        if (isSongUnique) {
            if (arrayOfCellData[0].count == 6) {
                songTitleData.removeLast()
                songTitleData.append(mediaItemCollection)
            } else if (editingCell) {
                songTitleData[cellIndexPath!] = mediaItemCollection
            } else {
                songTitleData.append(mediaItemCollection)
            }
            createCellDataForSongs()
        } else {
        }
        self.tableView.reloadData()
    }
    
    func isSongAlreadyChosen(theCollection: MPMediaItemCollection) -> Bool {
        
        if !(songTitleData.isEmpty) {
            
            for items in songTitleData {
                if items.items[0] == theCollection.items[0] {
                    return false
                }
            }
        }
        return true
    }
    
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("User selected Cancel tell me what to do")
        mediaPicker.dismiss(animated: true, completion: {})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: songTitleData), forKey: "savedSongTitles")
        super.viewWillDisappear(true)
    }
    
    // MARK: - Table view data source

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
