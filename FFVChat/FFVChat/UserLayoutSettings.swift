//
//  UserLayoutSettings.swift
//  FFVChat
//
//  Created by Filipo Negrao on 28/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension UserLayoutInfo
{
    @NSManaged var currentBackground: String?
    @NSManaged var currentTheme: String?
    @NSManaged var chatSounds: NSNumber?
    @NSManaged var otherSounds: NSNumber?
    @NSManaged var visualEffects: NSNumber?
}


class UserLayoutInfo: NSManagedObject {
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext) -> UserLayoutInfo
    {
        let info = NSEntityDescription.insertNewObjectForEntityForName("UserLayoutInfo", inManagedObjectContext: moc) as! UserLayoutInfo
        
        info.chatSounds = true
        info.otherSounds = true
        info.currentBackground = "blueSky"
        info.currentTheme = "Default"
        info.visualEffects = true
        
        return info
    }
}

private let data = UserLayoutSettings()

class UserLayoutSettings : NSObject
{
    var settings : UserLayoutInfo?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    let backgrounds = ["blueSky","redSky","redSky2","darkSky"]
    
    override init()
    {
        super.init()
        
        self.settings = self.getSettings()
        if(self.settings == nil)
        {
            self.settings = UserLayoutInfo.createInManagedObjectContext(self.managedObjectContext)
            self.save()
        }
    }
    
    class var sharedInstance : UserLayoutSettings
    {
        return data
    }
    
    func getBackgroundNames() -> [String]
    {
        return self.backgrounds
    }
    
    func getBackground(name: String) -> UIImage?
    {
        let image = UIImage(named: name)
        
        return image
    }
    
    func getBackgrounds() -> [UIImage]
    {
        var bgs = [UIImage]()
        
        for name in self.backgrounds
        {
            bgs.append(UIImage(named: name)!)
        }
        
        return bgs
    }
    
    func getDefaultBackground() -> UIImage
    {
        if(self.settings != nil)
        {
            return UIImage(named: self.settings!.currentBackground!)!
        }
        else
        {
            return UIImage(named: "blueSky")!
        }
    }
    
    func getChatSounds() -> Bool
    {
        if(self.settings != nil)
        {
            return Bool(self.settings!.chatSounds!)
        }
        else
        {
            return true
        }
    }
    
    func setChatSound(status: Bool)
    {
        if(self.settings != nil)
        {
            self.settings?.chatSounds = status
        }
        
        self.save()
    }
    
    func getOtherSounds() -> Bool
    {
        if(self.settings != nil)
        {
            return Bool(self.settings!.otherSounds!)
        }
        else
        {
            return true
        }
    }
    
    func setOtherSound(status: Bool)
    {
        if(self.settings != nil)
        {
            self.settings?.otherSounds = status
        }
        
        self.save()
    }
    
    func getVisualEffects() -> Bool
    {
        if(self.settings != nil)
        {
            return Bool(self.settings!.visualEffects!)
        }
        else
        {
            return true
        }
    }
    
    func setVisualEffects(status: Bool)
    {
        if(self.settings != nil)
        {
            self.settings!.visualEffects = status
            self.save()
        }
    }
    
    func getSettings() -> UserLayoutInfo?
    {
        let request = NSFetchRequest(entityName: "UserLayoutInfo")
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [UserLayoutInfo]
            if(results.count > 1)
            {
                self.managedObjectContext.delete(results.last)
            }
            
            return results.last
        }
        catch
        {
            return nil
        }
    }
    
    // Save function.
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
    
}
