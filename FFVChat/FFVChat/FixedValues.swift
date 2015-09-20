//
//  FixedValues.swift
//  FFVChat
//
//  Created by Filipo Negrao on 19/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation



enum UserCondition : String
{
    case userLogged = "userLogged"
    
    case wrongPassword = "wrongPassword"
    
    case userNotFound = "userNotFound"
    
    case emailInUse = "emailInUse"
    
    case userLoggedOut = "userLoggedOut"
    
    case userAlreadyExist = "userAlreadyExist"
    
    case userRegistered = "userRegistered"
}


extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
}