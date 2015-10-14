//
//  FixedValues.swift
//  FFVChat
//
//  Created by Filipo Negrao on 19/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

let screenSize: CGRect = UIScreen.mainScreen().bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let lightBlue = UIColor(netHex: 0x03bbff)
let lightGray = UIColor(netHex: 0x343539)
let lightGreen = UIColor(hex: 0x5c9b5b)

let oficialGreen = UIColor(netHex: 0x08e7c5)
let oficialDarkGray = UIColor(netHex: 0x343539)
let oficialLightGray = UIColor(netHex: 0xa1a5a4)
let oficialBlue = UIColor(netHex: 0x1a4dd0)
let badTrust = UIColor(netHex: 0xa31c24)
let badTrustNav = UIColor(netHex: 0x76141a)
let goodTrust = UIColor(netHex: 0x356847)
let goodTrustNav = UIColor(netHex: 0x314e39)


class FixedValues
{
    
}
//determina o tamanho da tela


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
    
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}