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

let oficialGreen = UIColor(hex: 0x5ebdb1) //verde padrão
let oficialDarkGreen = UIColor(hex: 0x436b69) //detalhes telas de login
let oficialDarkGray = UIColor(hex: 0x313235) //navs e alguns backgrounds
let oficialMediumGray = UIColor(hex: 0x3a3b3e) //background contatos e chat
let oficialSemiGray = UIColor(hex: 0x454548) //usado na tela de importação e config
let oficialLightGray = UIColor(hex: 0xa0a4a5) //textos e ícones
let oficialRed = UIColor(hex: 0xc70040) //círculo trust level negativo tela destinatário
let badTrust = UIColor(hex: 0x540305) //background chat negativo
let badTrustNav = UIColor(hex: 0x470204) //nav chat negativo


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

extension Int
{
    
    func mod(mod : Int) -> Int{
        let n = self/mod;
        return self - n*mod;
    }
    
}

//PARA AUMENTAR O TAMANHO DA FONTE
extension UILabel
{
    func setSizeFont(sizeFont: CGFloat)
    {
        self.font = UIFont(name: self.font.fontName, size: sizeFont)!
    }
}


//Para pegar strings entre duas strings
extension String {
    func sliceFrom(start: String, to: String) -> String? {
        return (rangeOfString(start)?.endIndex).flatMap { sInd in
            (rangeOfString(to, range: sInd..<endIndex)?.startIndex).map { eInd in
                substringWithRange(sInd..<eInd)
            }
        }
    }
}