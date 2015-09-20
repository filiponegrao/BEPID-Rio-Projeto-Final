//
//  DAOUser.swift
//  FFVChat
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4

class DAOUser
{
    /* Funcao assincrona que executa o login com o parse;
     * A funcao nao retorna nenhuma condicao de retorno,
     * entretanto ao executar o login emite uma notificacao
     * contida em UserConditions
     */
    class func loginParse(username: String, password: String)
    {
        PFUser.logInWithUsernameInBackground(username, password:password)
            {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil
            {
                //Searching for mail
                let query = PFUser.query()
                query!.whereKey("username", equalTo: username)
                
                query!.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil
                    {
                        if let objects = objects as? [PFObject]
                        {
                            let user = objects[0]
                            let email = user["email"] as! String
                            let trustLevel = user["trustLevel"] as! Int
                            DAOUser.setEmail(email)
                            DAOUser.setUserName(username)
                            DAOUser.setPassword(password)
                            DAOUser.setTrustLevel(trustLevel)
                            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                        }
                    }
                    else
                    {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userNotFound.rawValue, object: nil)
            }
        }
    }
    
    /* Funcao assincrona que executa o login no Parse
     * via Facebook (Parse é do Facebook);
     * A funcao nao retorna nenhuma condicao de retorno,
     * entretanto ao executar o login emite uma notificacao
     * contida em UserConditions
     */
    class func loginFaceParse()
    {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(nil) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user
            {
                if user.isNew
                {
                    print("User signed up and logged in through Facebook!")
                    user.setValue("usernames", forKey: "username")
                }
                else
                {
                    print("User logged in through Facebook!")
                }
            }
            else
            {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    /* Funcao efetua o logout de um usuario!
     * Sua condicao de retorno é um par : booleano
     * e string, onde o primeiro indica se o logout
     * foi efeutaod corretamente e o segundo a descricao
     * de um possivel erro
     */
    class func logOut() -> (done: Bool, error: String)
    {
        PFUser.logOut()
        DAOUser.setUserName("")
        DAOUser.setEmail("")
        DAOUser.setLastSync("")
        DAOUser.setPassword("")
        DAOUser.setTrustLevel(-1)
        
        return (done: true, error: "")
    }
    
    class func registerUser(username: String, email: String, password: String, photo: UIImage)
    {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
    
        // other fields can be set just like with PFObject
        user["trustLevel"] = 100
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error
            {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                if(error.code == 202)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userAlreadyExist.rawValue, object: nil)
                }
                else if(error.code == 203)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.emailInUse.rawValue, object: nil)
                }
                // Show the errorString somewhere and let the user try again.
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userRegistered.rawValue, object: nil)
                self.loginParse(username, password: password)
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
//                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            
//                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                
                do { try fileManager.copyItemAtPath(bundlePath, toPath: path)
                    print("User info criado com sucesso!...")
                }
                catch
                {
                    print("User could not be created for some reason - bytes or whatever")
                }
            }
            else
            {
                print("UserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
        }
        else
        {
            print("UserInfo.plist already exits at path.")
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
    class func getUserName() -> String!
    {
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return ""
            }
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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return ""
            }
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
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return ""
            }
        }
        
        let sync = content!.valueForKey("ultimaSincronizacao") as? String
        
        if(sync == nil)
        {
            return ""
        }
        
        return sync!
    }
    
    
    class func getTrustLevel() -> Int
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return -1
            }
        }
        
        let tl = content!.valueForKey("trustLevel") as? Int
        
        if(tl == nil)
        {
            return -1
        }
        
        return tl!
    }
    
    
    class func getPassword() -> String
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return ""
            }
        }
        
        let password = content!.valueForKey("password") as? String
        
        if(password == nil)
        {
            return ""
        }
        
        return password!
    }
    

    class func setLastSync(sync: String)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return
            }
        }
        
        content!.setValue(sync, forKey: "ultimaSincronizacao")
        content!.writeToFile(path, atomically: false)
    }
    
    class func setUserName(name: String)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return
            }
        }
        
        content!.setValue(name, forKey: "nome")
        content!.writeToFile(path, atomically: true)
        
    }
    
    class func setEmail(email: String)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return
            }
        }
        
        content!.setValue(email, forKey: "email")
        content!.writeToFile(path, atomically: true)
        
    }
    
    
    class func setPassword(password: String)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return
            }
        }
        
        content!.setValue(password, forKey: "password")
        content!.writeToFile(path, atomically: true)
        
    }
    
    
    class func setTrustLevel(trustLevel: Int)
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist") as String
        let content = NSMutableDictionary(contentsOfFile: path)
        
        if(content == nil)
        {
            self.initUserInformation()
            
            if(content == nil)
            {
                return
            }
        }
        
        content!.setValue(trustLevel, forKey: "trustLevel")
        content!.writeToFile(path, atomically: true)
        
    }
    
    class func isLoged() -> Bool
    {
        let email = self.getUserName()
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

