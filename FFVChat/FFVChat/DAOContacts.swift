//
//  DAOContacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


enum ContactCondRet : String
{
    case Ok
    
    case ContactNotFound
}

enum ContactNotification : String
{
    case contactAdded = "contactAdded"
}

class DAOContacts
{
    
    class func initContacts()
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("Contacts", ofType: "plist")
            {
                //                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path) }
                catch
                {
                    print("nao foi possivel criar a pasta")
                }
            }
            else
            {
                print("Contacts.plist not found. Please, make sure it is part of the bundle.")
            }
        }
        else
        {
            print("Contacts.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
    }
    
    
    class func getAllContacts() -> [Contact]
    {
        var contacts = [Contact]()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            print("retornando pq nao tem nada em content")
            return contacts
        }
        
        for(var i = 0; i < content?.count; i++)
        {
            let data = content?.allValues[i].valueForKey("thumb") as! NSData
            let image = UIImage(data: data)
            contacts.append( Contact(username: content?.allValues[i].valueForKey("username") as! String, registerDate: content?.allValues[i].valueForKey("createdAt") as! String, thumb: image!))
            print(contacts)
        }
        
        return contacts
    }
    
    
    class func getContact(username: String) -> Contact?
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            print("retornando pq nao tem nada em content")
            return nil
        }
        
        let data = content?.objectForKey(username) as? NSDictionary
        
        if(data == nil)
        {
            return nil
        }
        
        let contact = Contact(username: data?.valueForKey("username") as! String, registerDate: data?.valueForKey("createdAt") as! String, thumb: UIImage(data: data!.objectForKey("thumb") as! NSData)!)
        
        print("contato recuperado com sucesso")
        return contact
    }

    
    class func deleteContact(username: String)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return
        }
    }
    
    
    class func addContactByUsername(username: String, callback: (success: Bool, error: NSError?) -> Void) -> Void
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initContacts()
            content = NSMutableDictionary(contentsOfFile: path)
        }
        
        if(DAOUser.sharedInstance.getUserName() == username)
        {
            callback(success: false, error: error_selfUser)
        }
        
        DAOParse.getContactFromParse(username) { (contact, error) -> Void in
            
            if(contact != nil)
            {
                let cont = ["username" : contact!.username, "createdAt" : contact!.registerDate, "thumb" : contact!.thumb.highestQualityJPEGNSData]
                content!.setObject(cont, forKey: contact!.username)
                content!.writeToFile(path, atomically: false)
            }
            else
            {
                callback(success: false, error: error)
            }
            
        }
    }
    
    
    class func addContactByID(id: String, callback: (success: Bool, error: NSError?) -> Void) -> Void
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initContacts()
            content = NSMutableDictionary(contentsOfFile: path)
        }
        
        if(DAOUser.sharedInstance.getFacebookID() == id)
        {
            callback(success: false, error: error_selfUser)
        }
        
        
        DAOParse.getContactFromParseWithID(id) { (contact, error) -> Void in
            
            if(contact != nil)
            {
                let cont = ["username" : contact!.username, "createdAt" : contact!.registerDate, "thumb" : contact!.thumb.highestQualityJPEGNSData]
                content!.setObject(cont, forKey: contact!.username)
                content!.writeToFile(path, atomically: false)
                callback(success: true, error: nil)
            }
            else
            {
                callback(success: false, error: error)
            }
            
        }
    }
    
    
    class func searchUsersWithString(string: String, callback: ([metaContact]) -> Void) -> Void
    {
        var result = [metaContact]()
        
        DAOParse.getUsersWithString(string) { (users: [metaContact]) -> Void in
            
            result = users
            callback(result)
        }
    }
    
    
    class func isContact(username: String) -> Bool
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("Contacts.plist") as String
        
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return false
        }
        
        let contacts = self.getAllContacts()
        
        for contact in contacts
        {
            if(username == contact.username)
            {
                return true
            }
        }
        
        return false
    }
    
}





