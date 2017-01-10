//
//  UserTheme.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-16.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import Foundation
import UIKit

class UserTheme {
    
    private var dayTheme = "whiteTheme"
    private var nightTheme = "blackTheme"
    private var currentUserTheme = "blackTheme"
    static let userThemeInstance = UserTheme()

    func getUserTheme() -> String {
        return currentUserTheme
    }
    
    func setCurrentUserTheme(userThemeString: String) {
        currentUserTheme = userThemeString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userThemeChanged"), object: nil)
    }
    
    func setBlack(theController: UITableViewController) {
        theController.tableView.backgroundColor = UIColor.black
        theController.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        theController.navigationController?.navigationBar.tintColor = UIColor.white;
        theController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    func setWhite(theController: UITableViewController) {
        theController.tableView.backgroundColor = UIColor.white
        theController.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent;
        theController.navigationController?.navigationBar.tintColor = UIColor.black;
        theController.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        UIApplication.shared.statusBarStyle = .default

    }
    
    
}
