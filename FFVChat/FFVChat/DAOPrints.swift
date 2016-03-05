//
//  DAOPrints.swift
//  FFVChat
//
//  Created by Filipo Negrao on 28/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreData

private let data = DAOPrints()

class DAOPrints
{
    var prints : [PrintscreenNotification]!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init()
    {
        
    }
    
    class var sharedInstance : DAOPrints
    {
        return data
    }
    
    
    func sendPrintscreenNotification(imageKey: String, sender: String)
    {
        let now = NSDate()
        
        DAOPostgres.sharedInstance.sendPrintScreen(imageKey, sender: sender, printDate: now)
    }
    
    
    func getPrintscreenNotficiations() -> [PrintscreenNotification]
    {
        var prints = [PrintscreenNotification]()
        
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results
        }
        catch
        {
            return prints
        }
    }
    
    func getPrintscreen(imageKey: String) -> PrintscreenNotification?
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results.first
        }
        catch
        {
            return nil
        }
    }
    
    func addPrintscreenNotification(printer: String, imageKey: String, printDate: NSDate) -> PrintscreenNotification?
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            if(results.count == 0)
            {
                let image = DAOSentMidia.sharedInstance.sentMidiaImageForKey(imageKey)
                let print = PrintscreenNotification.createInManagedObjectContext(self.managedObjectContext, printer: printer, image: image?.highestQualityJPEGNSData, imageKey: imageKey, printDate: printDate)
                self.save()
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationController.center.printScreenReceived.name, object: nil, userInfo: ["printScreen": print])
                return print
                
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    func getNumberOfPrintScreensReceived(contact: String) -> Int
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "printer == %@ AND status == %@", contact, PrintScreenStatus.received.rawValue)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results.count
        }
        catch
        {
            return 0
        }
    }
    
    func getNumberOfPrintScreens(contact: String) -> Int
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "printer == %@", contact)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results.count
        }
        catch
        {
            return 0
        }
    }
    
    func getNumberOfPrintScreensSeen(contact: String) -> Int
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "printer == %@ AND status == %@", contact, PrintScreenStatus.seen.rawValue)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results.count
        }
        catch
        {
            return 0
        }
    }
    
    func getNumberOfAllPrintScreensReceived() -> Int
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        fetchRequest.predicate = NSPredicate(format: "status == %@", PrintScreenStatus.received.rawValue)
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            return results.count
        }
        catch
        {
            return 0
        }
    }
    
    
    func setPrintScreenSeen(printscreen: PrintscreenNotification)
    {
        printscreen.status = PrintScreenStatus.seen.rawValue
        
        self.save()
    }
    
    func setPrintScreenHidden(printscreen: PrintscreenNotification)
    {
        printscreen.status = PrintScreenStatus.hidden.rawValue
        
        self.save()
    }
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
}