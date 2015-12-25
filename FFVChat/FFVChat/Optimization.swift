//
//  Optimization.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class Optimization
{
    /** Retorna somente as horas e minutos */
    class func getStringDateFromDate(date: NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.stringFromDate(date)
        
        return date
    }
    
    /** Recebe uma view e adiciona uma sombra por tras */
    class func addShadowOnView(view: UIView)
    {
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(5, 5)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).CGPath
    }
    
    /** 
     * Retorna a string que contem a data passada, estando
     * presentes o ano, mes, dia, as horas, minutos e segundos
     */
    class func getBigStringFromDate(date: NSDate) -> String
    {
        var string = "\(date)" as NSString
        
        string = string.substringWithRange(NSMakeRange(0, 19))
        
        return string as String
    }
    
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    class func removeWhiteSpaces(string: String) -> String
    {
        let replaced = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return replaced
    }
    
    
    /**
     * Converte um vetor de strings para NSData.
     */
    class func stringArrayToData(array: [String]) -> NSData
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(array)
        
        return data
    }
    
    /**
     * Converte um NSData para um vetor de Strings
     */
    class func dataToStringArray(data: NSData) -> [String]?
    {
        if let array: [String] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String] {
            
            return array
        }
        else
        {
            return nil
        }
    }
}








