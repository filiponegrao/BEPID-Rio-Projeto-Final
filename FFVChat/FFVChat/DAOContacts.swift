//
//  DAOContacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation



enum ContactCondRet
{
    case Ok
    
    case ContactNotFound
    
    
}

class DAOContacts
{
    
    class func initContacts()
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            do { try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                
                print("Pasta de contatos criada com sucesso")
            }
            catch
            {
                print("Deu merda ao criar a pasta de contatos")
            }
        }
    }
    
    
    class func getAllContacts() -> (condRet: ContactCondRet, contacts: [Contacts]?)
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("Contacts")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath))
        {
            self.initContacts()
        }
        
        
        
    }

    
    
}