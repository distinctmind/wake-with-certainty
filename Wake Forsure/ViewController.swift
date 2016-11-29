//
//  ViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-11-27.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var helloWorldTimer = Timer.scheduledTimer(timeInterval: 01.0, target: self, selector: Selector("changeTime"), userInfo: nil, repeats: true)
        
        var upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTime() {
        
        dateFormatter.timeStyle = .medium
        var timeString = "\(dateFormatter.string(from: Date()))"
        timeLabel.text = timeString
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        print("hello")
        if (sender.direction == .up) {
            self.performSegue(withIdentifier: "showAlarmClocks", sender: nil)
        }
    }

}

