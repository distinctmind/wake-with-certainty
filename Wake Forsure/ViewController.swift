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
    var userTheme = UserTheme.userThemeInstance
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.title = "Clock"
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let dayNightSwitch = DayNightSwitch(frame: CGRect(x: 20, y: 30, width: 60, height: 30))
        
        dayNightSwitch.changeAction = { on in
            print("The switch is now " + (on ? "on" : "off"))
        }
        
        self.view.addSubview(dayNightSwitch)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayThemeOn), name: NSNotification.Name(rawValue: "dayThemeOn"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: Selector("changeTime"), userInfo: nil, repeats: true)
        
        if (userTheme.getUserTheme() == "blackTheme") {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dayThemeOn(notification: NSNotification) {
        
        if (notification.object as! Bool == false) {
            userTheme.setCurrentUserTheme(userThemeString: "blackTheme")
            self.view.backgroundColor = UIColor.black
            timeLabel.textColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent

        } else {
            userTheme.setCurrentUserTheme(userThemeString: "whiteTheme")
            timeLabel.textColor = UIColor.black
            self.view.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default

        }
        
    }
    
    func changeTime() {
        
        dateFormatter.timeStyle = .medium
        let timeString = "\(dateFormatter.string(from: Date()))"
        timeLabel.text = timeString
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        if (sender.direction == .up) {
            let alarmTable = self.storyboard?.instantiateViewController(withIdentifier: "showAlarmClocks") as? AlarmTableViewController
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(alarmTable!, animated: true)
        }
    }
    
}

