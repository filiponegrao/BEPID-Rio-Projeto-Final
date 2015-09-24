//
//  Contacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation

class Contacts
{
    let username : String!
    
    let faceUsername : String!
        
    let registerDate : NSDate!
    
    let numberOfReports : Int!
    
    let numberOfScreenshots : Int!
    
    let trustLevel : Int!
    
    init(username: String, faceUsername: String, registerDate: NSDate, numberOfReports: Int, mumberOfScreenshots: Int, trustLevel: Int)
    {
        self.username = username
        self.faceUsername = faceUsername
        self.registerDate = registerDate
        self.numberOfReports = numberOfReports
        self.numberOfScreenshots = mumberOfScreenshots
        self.trustLevel = trustLevel
    }
    
}