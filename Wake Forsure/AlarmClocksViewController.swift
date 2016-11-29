//
//  AlarmClocksViewController.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-11-28.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import UIKit

class AlarmClocksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
