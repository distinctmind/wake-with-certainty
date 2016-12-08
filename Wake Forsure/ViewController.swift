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
        var upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: Selector("changeTime"), userInfo: nil, repeats: true)
        super.viewWillAppear(true)
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
        
        if (sender.direction == .up) {
            self.performSegue(withIdentifier: "showAlarmClocks", sender: nil)
        }
    }

}

