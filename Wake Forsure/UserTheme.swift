//
//  UserTheme.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-16.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import Foundation

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
    
}
