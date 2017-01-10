//
//  HeaderTableViewCell.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-27.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var songHeaderLabel: UILabel!
    @IBOutlet weak var addSongButton: UIButton!
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     */
    @IBAction func addSongButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSongButtonPressed"), object: nil)
    }
    
}
