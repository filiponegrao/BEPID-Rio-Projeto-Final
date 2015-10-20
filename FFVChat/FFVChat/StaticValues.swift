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

let oficialGreen = UIColor(netHex: 0x08e7c5)
let oficialDarkGray = UIColor(netHex: 0x343539)
let oficialMediumGray = UIColor(netHex: 0x53555a)
let oficialLightGray = UIColor(netHex: 0xa1a5a4)
let oficialBlue = UIColor(netHex: 0x1d71d6)
let badTrust = UIColor(netHex: 0x540305)
let badTrustNav = UIColor(netHex: 0x470204)
let goodTrust = UIColor(netHex: 0x356847)
let goodTrustNav = UIColor(netHex: 0x314e39)

let mySelf = DAOUser.sharedInstance.getUserName()


//*** CELL SIZES AND PROPERTIES ******///
let cellWidth = screenWidth
let cellHeightDefault : CGFloat = 40

let margemLateral : CGFloat = 30
let margemVertical : CGFloat = 5

let cellBackgroundWidth : CGFloat = screenWidth - (2 * margemLateral)
let cellBackgroundHeigth : CGFloat = cellHeightDefault - (2 * margemVertical)

let cellTextWidth = cellBackgroundWidth - (2 * margemLateral)
let cellTextHeigth = cellBackgroundHeigth - (2 * margemVertical) - 10

let dateTextHeigth : CGFloat = 10
let dateTextWidth : CGFloat = 80

let cellImageWidth : CGFloat = cellBackgroundWidth - (2 * margemLateral)
let cellImageHeigth : CGFloat = cellImageWidth


let textMessageFont = UIFont(name: "Helvetica", size: 16)

//*** END CELL SIZES AND PROPERTIES **//


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

extension Int{
    
    func mod(mod : Int) -> Int{
        let n = self/mod;
        return self - n*mod;
    }
    
}