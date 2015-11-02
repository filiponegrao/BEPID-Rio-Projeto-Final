//
//  DAOSentMidia.swift
//  FFVChat
//
//  Created by Filipo Negrao on 02/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData


private let data : DAOSentMidia = DAOSentMidia()

class DAOSentMidia
{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    init()
    {
        
    }
    
    class var sharedInstance : DAOSentMidia
    {
        return data
    }
    
    
    func sentMidiaFor(contact: Contact) -> [SentMidia]
    {
        let fetch = NSFetchRequest(entityName: "SentMidia")
        
        let predicate = NSPredicate(format: "target == %@", contact.username)
        
        fetch.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
        
            return results
        }
        catch {
        
            return [SentMidia]()
        }
    }
    
    
    func addSentMidia(message: Message)
    {
        if(message.image == nil)
        {
            return
        }
        
        let fetch = NSFetchRequest(entityName: "SentMidia")
        
        let predicate = NSPredicate(format: "sentDate == %@", message.sentDate)
        
        fetch.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
            
            if(results.first != nil)
            {
                results.first?.lastSent = NSDate()
            }
            else
            {
                let sent = SentMidia.createInManagedObjectContext(self.managedObjectContext, sentDate: message.sentDate, target: message.target, image: message.image!, lastSent: NSDate())
                self.save()
            }
        }
        catch {
            
            return
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
