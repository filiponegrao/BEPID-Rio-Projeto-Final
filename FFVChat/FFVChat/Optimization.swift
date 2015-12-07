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
}

