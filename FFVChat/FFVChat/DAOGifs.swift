//
//  DAOGifs.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Parse

private let data = DAOGifs()


class DAOGifs : NSObject
{
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override init()
    {
        super.init()
        self.checkNewGifsFromServer()
    }
    
    class var sharedInstance : DAOGifs
    {
        return data
    }
    
    
    func checkNewGifsFromServer()
    {
        
        if(PFUser.currentUser() != nil)
        {
            let query = PFQuery(className: "Gifs")
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if let objects = objects as? [PFObject]
                {
                    for object in objects
                    {
                        let name = object["name"] as! String
                        if(!self.gifAlreadyExist(name))
                        {
                            let launchedDate = object.valueForKey("createdAt") as! NSDate
                            let text = object.valueForKey("hashtags") as! NSMutableArray
                            let hashtags = NSKeyedArchiver.archivedDataWithRootObject(text)
                            let file = object.objectForKey("gif") as! PFFile
                            file.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                
                                if(data != nil)
                                {
                                    self.addGif(name, data: data!, launchedDate: launchedDate, hashtags: hashtags)
                                    NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.gifDownloaded)
                                }
                            })
                        }
                    }
                }
                
            })
        }
      
    }
    
    
    func getGifs() -> [Gif]
    {
        let fetchRequest = NSFetchRequest(entityName: "Gif")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Gif]
            return results
        }
        catch
        {
            return [Gif]()
        }
        
    }
    
    func addGif(name: String, data: NSData, launchedDate: NSDate, hashtags: NSData)
    {
        let fetchRequest = NSFetchRequest(entityName: "Gif")
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Gif]
            if(results.count == 0)
            {
                let gif = Gif.createInManagedObjectContext(self.managedObjectContext, name: name, data: data, launchedDate: launchedDate, hashtags: hashtags)
                self.save()
            }
        }
        catch
        {
            return
        }
        return
    }
    
    func getGifFromName(name: String) -> NSData?
    {
        let fetchRequest = NSFetchRequest(entityName: "Gif")
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Gif]
            return results.first?.data
        }
        catch
        {
            return nil
        }
    }
    
    func gifAlreadyExist(name: String) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "Gif")
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Gif]
            if(results.count > 0)
            {
                return true
            }
            else { return false }
        }
        catch
        {
            return false
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



