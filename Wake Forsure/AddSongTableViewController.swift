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

//This is used to store data about my cells
struct cellData {
    
    //Cell is a integer that represents the type of cell (Header 1 or 2 or Song Cell)
    let cell: Int!
    
    //Song is a string that represents what text to put in the cell
    let song: String!
    
}

class AddSongTableViewController: UITableViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var userSongsHeader: UILabel!
    @IBOutlet weak var songsHeader: UILabel!
    @IBOutlet weak var addSongButton: UIButton!
    
    var userThemes = UserTheme.userThemeInstance
    
    let mediaPicker = MPMediaPickerController(mediaTypes: .music)
    
    //All songs that user has chosen (At most 5)
    var songTitleData = [MPMediaItemCollection]()
    
    // --- The Song that will be assigned when user chooses --- //
    var songChosen: MPMediaItemCollection?
    var defaultSongChosen: [String: URL]?
    
    // --- The Song that user already chose --- //
    var songAlreadyChosen: MPMediaItemCollection?
    var defaultSongAlreadyChosen: [String: URL]?
    
    var editingCell = false
    
    var doneChoosingSong = false
    
    var cellIndexPath: Int?
    
    var arrayOfCellData = [[cellData]]()
    
    var selectedSongInfo = [String: Int]()
    
    var theSectionSelected = 0;
    
    var theRowSelected = 0;
    
    var userDidSelectAtRow: Bool?
    
    var theDefaultSongsUrl = [
        
            URL(fileURLWithPath: Bundle.main.path(forResource: "Respiration", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "Surfin", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "With Me", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "Lovely Day", ofType: "mp3")!),
            URL(fileURLWithPath: Bundle.main.path(forResource: "everytime", ofType: "mp3")!)
        
                           ]
    
    var theDefaultSongsPlayer = [AVAudioPlayer]()
    
    let image2 = #imageLiteral(resourceName: "whiteCheckMark")
    let image = #imageLiteral(resourceName: "whiteCheckMark2")
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createSongPlayer()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        
        //Extract all the Custom Song choices
        if let songTitlesData = defaults.object(forKey: "savedSongTitles") as? NSData {
            
            songTitleData = (NSKeyedUnarchiver.unarchiveObject(with: songTitlesData as Data) as? [MPMediaItemCollection]? ?? [MPMediaItemCollection]())!
        }
        
        //Extract the current song position information
        selectedSongInfo = defaults.object(forKey: "selectedSongInfo") as? [String: Int] ?? ["9":9]
        
        //The array for representing the different cells
        // --see struct at top of class for more information --
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
        
        //Populate cellData with all the custom songs from the songTitlesData
        // --This is done to allow the Table View to display all the new cells --
        createCellDataForSongs(userDidSelectAtRow: true)
        
        //User is coming with a CUSTOM song already chosen
        if (songAlreadyChosen != nil) {
            
            //If the song is Unique
            if (isSongAlreadyChosen(theCollection: songAlreadyChosen!).value) {
                
                //If the array is at its max
                if (songTitleData.count == 5) {
                    
                    //Pushing new song that is unique to stack
                    songTitleData.removeFirst()
                    songTitleData.append(songAlreadyChosen!)
                    pushCellData(titleOfSong: (songAlreadyChosen?.items[0].title!)!)
                    selectedSongInfo = ["0":5]
                    
                } else {
                    //Appending new song that is unique to stack
                    songTitleData.append(songAlreadyChosen!)
                    createCellDataForSongs(userDidSelectAtRow: true)
                    selectedSongInfo = ["0":songTitleData.count]
                }
                defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
            
            //Song is not Unique
            } else {
                
                //Get the row of the custom song
                var theCustomSongRow = getCustomSongRow(theCustomsong: songAlreadyChosen!)
                selectedSongInfo = ["0":theCustomSongRow]
                defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
                
            }
            
        //User is coming with a DEFAULT song already chosen
        } else if ((defaultSongAlreadyChosen) != nil) {

            var theDefaultSongRow = getDefaultSongRow(theDefaultSong: defaultSongAlreadyChosen!)
            selectedSongInfo = ["1": theDefaultSongRow]
            defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name: NSNotification.Name(rawValue: "addSongButtonPressed"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if (userThemes.getUserTheme() == "blackTheme") {
            userThemes.setBlack(theController: self)
        } else {
            userThemes.setWhite(theController: self)
        }
        
        for (key,value) in selectedSongInfo {
            
            theSectionSelected = Int(key)!;
            theRowSelected = value
            
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
            cell.songHeaderLabel.text = arrayOfCellData[indexPath.section][indexPath.row].song
            cell.selectionStyle = .none
            setCellColor(theLabel: cell.songHeaderLabel, theCell: cell)
            return cell
            
        } else if (arrayOfCellData[indexPath.section][indexPath.row].cell == 2) {
            
            let cell = Bundle.main.loadNibNamed("Header2TableViewCell", owner: self, options: nil)?[0] as! Header2TableViewCell
            cell.songHeader2Label.text = arrayOfCellData[indexPath.section][indexPath.row].song
            cell.selectionStyle = .none
            setCellColor(theLabel: cell.songHeader2Label, theCell: cell)
            return cell
            
        } else {
            
            let cell = Bundle.main.loadNibNamed("SongTableViewCell", owner: self, options: nil)?[0] as! SongTableViewCell
            cell.songNameLabel.text = arrayOfCellData[indexPath.section][indexPath.row].song
            setCellColor(theLabel: cell.songNameLabel, theCell: cell)
            

            if (indexPath.section == 0) {
                
                if (theSectionSelected == 0) {

                    if (indexPath.row == theRowSelected) {
                        cell.checkMarkImage.image = image
                    } else {
                        cell.checkMarkImage.removeFromSuperview()
                        cell.checkMarkImage.image = nil

                    }
                }
                
                
            } else if (indexPath.section == 1) {
                
                if (theSectionSelected == 1) {
                    
                    if (indexPath.row == theRowSelected) {
                        cell.checkMarkImage.image = image
                    } else {
                        cell.checkMarkImage.removeFromSuperview()
                        cell.checkMarkImage.image = nil
                    }
                }

            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row != 0) {
                
                songChosen = songTitleData[indexPath.row-1]
                
                print(arrayOfCellData[0][indexPath.row].song)
                
                selectedSongInfo = ["0":indexPath.row]
                
                defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
                
                userDidSelectAtRow = true
                
                performSegue(withIdentifier: "saveSong", sender: self)
            }
            
        } else {
            
            defaultSongChosen = [arrayOfCellData[1][indexPath.row].song:theDefaultSongsUrl[indexPath.row-1]]
            
            selectedSongInfo = ["1": indexPath.row]
            
            defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
                        
            userDidSelectAtRow = true
            
            print(arrayOfCellData[1][indexPath.row].song)
            
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
    
    func getDefaultSongRow(theDefaultSong: [String: URL]) -> Int {
        
        var i = 1;
        
        for cellItems in arrayOfCellData[1][1..<5] {
            
            for key in theDefaultSong.keys {
                
                if cellItems.song == key {
                    return i
                }
                
                i = i + 1
            }
            
        }
        return i
    }
    
    func getCustomSongRow(theCustomsong: MPMediaItemCollection) -> Int {
        
        var i = 1;
        
        for cellItems in arrayOfCellData[0][1..<5] {
            
            if cellItems.song == theCustomsong.items[0].title! {
                return i
            }
            i = i + 1
            
        }
        return i
    }
    
    func createCellDataForSongs(userDidSelectAtRow: Bool) {
        
        var i = arrayOfCellData[0].count
        var songTitle = ""
        
        if (i == 6) {
            songTitle = songTitleData[songTitleData.count-1].items[0].title!
            pushCellData(titleOfSong: songTitle)
        }
        
        for songMediaItem in songTitleData[i-1 ..< songTitleData.endIndex] {
            
            songTitle = songMediaItem.items[0].title!
            
            if (i < 6) {
                arrayOfCellData[0].append(cellData(cell: 3, song: songTitle))
            }
            
            i = i + 1
        }
        
    }
    
    //Push elements in cellData forward in the stack
    func pushCellData(titleOfSong: String) {
        arrayOfCellData[0].remove(at: 1)
        arrayOfCellData[0].append(cellData(cell: 3, song: titleOfSong))
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
        
        //Dismiss view when user selects a song
        if (mediaItemCollection.count == 1) {
            mediaPicker.dismiss(animated: true, completion: {})
            doneChoosingSong = true
        }
        
        //Check if the song is Unique
        let isSongUniqueTuple = isSongAlreadyChosen(theCollection: mediaItemCollection)
        let isSongUnique = isSongUniqueTuple.value
        
        songChosen = mediaItemCollection
        
        if (isSongUnique) {
            
            //Array is at max, push element forward in stack
            if (arrayOfCellData[0].count == 6) {
                songTitleData.removeFirst()
                songTitleData.append(mediaItemCollection)
                selectedSongInfo = ["0":5]
            
            } else {
                songTitleData.append(mediaItemCollection)
                selectedSongInfo = ["0": songTitleData.count + 1]
            }
            createCellDataForSongs(userDidSelectAtRow: false)
            
        } else {
            selectedSongInfo = ["0":isSongUniqueTuple.index]
        }
        
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: songTitleData), forKey: "savedSongTitles")
        defaults.set(selectedSongInfo, forKey: "selectedSongInfo")
        
        for (key,value) in selectedSongInfo {
            theSectionSelected = Int(key)!;
            theRowSelected = value
        }
    
        self.tableView.reloadData()
    }
    
    func isSongAlreadyChosen(theCollection: MPMediaItemCollection) -> (value: Bool, index: Int) {
        
        var i = 1
        
        if !(songTitleData.isEmpty) {
            
            for items in songTitleData {
                
                if items.items[0] == theCollection.items[0] {
                    return (false,i)
                }
                
                i = i + 1
            }
        }
        
        return (true,i)
    }
    
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("User selected Cancel tell me what to do")
        mediaPicker.dismiss(animated: true, completion: {})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: songTitleData), forKey: "savedSongTitles")
        
        if (doneChoosingSong) {
            doneChoosingSong = false
            performSegue(withIdentifier: "saveSong", sender: self)
        }
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
