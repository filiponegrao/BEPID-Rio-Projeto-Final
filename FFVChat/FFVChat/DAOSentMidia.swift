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
        fetch.sortDescriptors = [NSSortDescriptor(key: "sentDate", ascending: true)]

        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
        
            return results
        }
        catch {
        
            return [SentMidia]()
        }
    }
    
    func reSendMidia(imageKey: String)
    {
        let fetch = NSFetchRequest(entityName: "SentMidia")
        
        let predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        fetch.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
            
            if(results.count > 0)
            {
                results.last?.lastSent = NSDate()
                self.save()
            }
        }
        catch {
            
            return
        }
        
        return
    }
    
    func sentMidiaImageForKey(imageKey: String) -> UIImage?
    {
        let fetch = NSFetchRequest(entityName: "SentMidia")
        
        let predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        fetch.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
            
            if(results.count > 0)
            {
                return UIImage(data: results.first!.image)!
            }
        }
        catch {
            
            return nil
        }
        
        return nil
    }
    
    
    func addSentMidia(message: Message)
    {
        //Encontra o mídia
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "imageKey == %@", message.contentKey!)
        do { let images = try self.managedObjectContext.executeFetchRequest(request) as! [Image]
            
            if(images.count > 0)
            {
                let image = images.first!
                
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
                        let sent = SentMidia.createInManagedObjectContext(self.managedObjectContext, sentDate: message.sentDate, target: message.target, image: image.data, lastSent: NSDate(), imageKey: message.contentKey!)
                        self.save()
                    }
                }
                catch {
                    
                    return
                }
                
            }
 
        
        }
        catch { return }
    }
    
    
    func deleteSentMidia(sentMidia: SentMidia)
    {
        self.managedObjectContext.deleteObject(sentMidia)
        self.save()
    }
    
    func deleteAllSentMidiaFrom(contact: String)
    {
        let fetch = NSFetchRequest(entityName: "SentMidia")
        
        let predicate = NSPredicate(format: "target == %@", contact)
        
        fetch.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetch) as! [SentMidia]
            
            if(results.count > 0)
            {
                for result in results
                {
                    self.managedObjectContext.deleteObject(result)
                    self.save()
                }
            }
            else
            {
                return
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
