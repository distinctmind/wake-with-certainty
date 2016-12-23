//
//  UserSwitchState.swift
//  Wake Forsure
//
//  Created by Jeanlouis Rebello on 2016-12-20.
//  Copyright © 2016 DistinctApps. All rights reserved.
//

import Foundation

var userSwitchStates = [Bool]()

class UserSwitchStates{
    
    func getArray() -> [Bool] {
        return userSwitchStates
    }
    
    func setArray(theArray: [Bool]) {
        userSwitchStates = theArray
    }
    
}
