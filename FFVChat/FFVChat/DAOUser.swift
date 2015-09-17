//
//  DAOUser.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse

class DAOUser
{
    
    class func logIn(username: String, password: String)
    {
        PFUser.logInWithUsernameInBackground(username, password:password)
            {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                NSNotificationCenter.defaultCenter().postNotificationName("userLogged", object: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("userNotFound", object: nil)
            }
        }
    }
    
    class func registerUser(username: String, email: String, password: String)
    {
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        // other fields can be set just like with PFObject
        user["trustLevel"] = 100
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("userRegistered", object: nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
    * Funcao que pega a plist existente no main bundle, e copia a mesma
    * para o documents. Isso acontence pois a mesma (criada no bundle)
    * serve apenas de referencia e modelo. A que sera modificavel e
    * aplicavel vai permanecer no documents.
    */
    class func initUserInformation()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("UserInfo", ofType: "plist")
            {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("User info criado com sucesso!...")
            }
            else
            {
                println("UserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
        }
        else
        {
            println("UserInfo.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
    }
    
    
    /**
    * Funcao que retorna o nome cadastro uma unica vez
    * do usuario do app
    * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
    * enquanto as de escrever utilizam o mutable dictionary
    **/
    class func getUserName() -> String
    {
        
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSDictionary(contentsOfFile: path)
        if(content == nil)
        {
            return ""
        }
        
        let nome = content!.valueForKey("nome") as? String
        
        if(nome == nil)
        {
            return ""
        }
        
        return nome!
    }
    
    
    /**
    * Funcao que retorna o email do usuario
    *
    * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
    * enquanto as de escrever utilizam o mutable dictionary
    **/
    class func getEmail() -> String
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return ""
        }
        
        let email = content!.valueForKey("email") as? String
        
        if(email == nil)
        {
            return ""
        }
        
        return email!
    }
    
    
    class func getLastSync() -> String
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return ""
        }
        
        let sync = content!.valueForKey("ultimaSincronizacao") as? String
        
        if(sync == nil)
        {
            return ""
        }
        
        return sync!
    }
    
    
    class func setLastSync(sync: String)
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return
        }
        
        content!.setValue(sync, forKey: "ultimaSincronizacao")
        content!.writeToFile(path, atomically: false)
    }
    
    class func setUserName(name: String)
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return
        }
        
        content!.setValue(name, forKey: "nome")
        content!.writeToFile(path, atomically: true)
        
    }
    
    class func setEmail(email: String)
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        var content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            return
        }
        
        content!.setValue(email, forKey: "email")
        content!.writeToFile(path, atomically: true)
        
    }
    
    
    class func isLoged() -> Bool
    {
        let email = self.getEmail()
        if(email != "")
        {
            return true
        }
        else
        {
            return false
        }
    }

}