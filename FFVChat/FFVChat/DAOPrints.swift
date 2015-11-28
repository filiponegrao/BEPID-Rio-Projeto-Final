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
        self.loadPrintNotifications()
    }
    
    class var sharedInstance : DAOPrints
    {
        return data
    }
    
    
    func sendPrintscreenNotification(imageKey: String, sender: String)
    {
        let date = NSDate()
        
        let printS = PFObject(className: "Printscreens")
        printS["sender"] = sender
        printS["printer"] = DAOUser.sharedInstance.getUsername()
        printS["printDate"] = date
        printS["status"] = "sent"
        printS["imageKey"] = imageKey
        
        print("enviando notificao de print...")
        printS.saveEventually { (success: Bool, error: NSError?) -> Void in
            if(success)
            {
                print("notificacao de print enviada com sucesso para \(sender)")
                DAOParse.pushPrintscreenNotification(sender)
            }
            else
            {
                print(error)
            }
        }
    }

    
    func getPrintscreenNotificationsFromParse()
    {
        let query = PFQuery(className: "Printscreens")
        query.whereKey("sender", equalTo: DAOUser.sharedInstance.getUsername())
        query.whereKey("status", equalTo: "sent")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let objects = objects as? [PFObject]
            {
                for object in objects
                {
                    let printer = object.valueForKey("printer") as! String
                    let imageKey = object.valueForKey("imageKey") as! String
                    let printDate = object.valueForKey("printDate") as! NSDate
                    
                    let print = self.addPrintscreenNotification(printer, imageKey: imageKey, printDate: printDate)
                    if(print != nil)
                    {
                        self.prints.append(print!)
                        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.printScreenReceived)
                    }
                    object["status"] = "received"
                    object.saveEventually()
                }
            }
        }
    }
    
    
    func getPrintscreenNotficiations() -> [PrintscreenNotification]
    {
        return self.prints
    }
    
    
    private func loadPrintNotifications()
    {
        let fetchRequest = NSFetchRequest(entityName: "PrintscreenNotification")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PrintscreenNotification]
            self.prints = results
        }
        catch
        {
            return
        }
        return
    }
    
    
    private func addPrintscreenNotification(printer: String, imageKey: String, printDate: NSDate) -> PrintscreenNotification?
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
    
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
}