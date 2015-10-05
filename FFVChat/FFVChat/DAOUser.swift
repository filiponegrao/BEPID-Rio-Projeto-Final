//
//  DAOUser.swift
//  Modulo de usuário genérico, com banco de dados Parse
//
//
//  Created by Filipo Negrao on 12/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.


import Foundation
import Parse
import ParseFacebookUtilsV4


enum UserCondition : String
{
    /** Notficacao responsavel por avisar quando o usaurio estiver
     logad na aplicacao */
    case userLogged = "userLogged"

    /** Notficacao responsavel por avisar ao usuario que a senha
     esta incorreta */
    case wrongPassword = "wrongPassword"

    case userNotFound = "userNotFound"

    case emailInUse = "emailInUse"

    case userLoggedOut = "userLoggedOut"

    case userAlreadyExist = "userAlreadyExist"

    /** Notificaao responsavel por informar que houve SUCESSO
     ao registrar o usuario */
    case userRegistered = "userRegistered"
    
    /** Login cancelado por algum motivo, pelo usuario ou
     pelo sistema */
    case loginCanceled = "loginCanceled"

    /** Notficacao responsavel por encaminhar o usuario para
     a tela de confirmacao de senha apos logar-se com o
     Facebook */
    case incompleteRegister = "incompleteRegister"
    
    /** Notificacao responsavel por avisar quando os contatos do usuario
     * foram carregados com sucesso */
    case contactsLoaded = "contactsLoaded"
}

private let data : DAOUser = DAOUser()

class DAOUser
{
    var user : PFUser!
    
    init()
    {
        print("init naclasse tu quer ver?")
        let username = self.getUserName()
        let password = self.getPassword()
        if(username != "" && password != "" && PFUser.currentUser() == nil)
        {
            PFUser.logInWithUsernameInBackground(username, password:password) {
                (user: PFUser?, error: NSError?) -> Void in
                print("entrando aqui")

                if user != nil
                {
                    print("logado")
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                }
                else
                {
                    print("deu merda")
                }
            }
        }
        else
        {
            print("nao e nulo")
            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
        }
    }
    
    
    class var sharedInstance : DAOUser
    {
        return data
    }

    
    /** Funcao que cadastra manualmente um novo
     * usuario no Parse. Possui um certo delay,
     * por nao usar callback, nao retorna nada,
     * mas apos o sucesso envia uma notifiacao
     * contida em uma das notificacoes em
     * UserCondition
     */
    func registerUser(username: String, email: String, password: String, photo: UIImage)
    {
        let data = photo.mediumQualityJPEGNSData
        let picture = PFFile(data: data)

        let user = PFUser()

        user.username = username
        user.password = password
        user.email = email

        // other fields can be set just like with PFObject
        user["trustLevel"] = 100
        user["profileImage"] = picture

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
                print("Usuario criado!")
                self.loginParse(username, password: password)
            }
        }
    }



    /** Funcao assincrona que executa o login com o parse;
      * A funcao nao retorna nenhuma condicao de retorno,
      * entretanto ao executar o login emite uma notificacao
      * contida em UserConditions
      */
    func loginParse(username: String, password: String)
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
                            let id = user.objectId
                            let data = user["profileImage"] as! PFFile
                            data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                
                                let image = UIImage(data: data!)
                                self.setEmail(email)
                                self.setUserName(username)
                                self.setPassword(password)
                                self.setTrustLevel(trustLevel)
                                self.setProfileImage(image!)
                                self.setParseKey(id!)
                                print("Usuario logado!")
                                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                                
                            })
                        }
                    }
                    else
                    {
                        print("Error: \(error!) \(error!.userInfo)")
                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.loginCanceled.rawValue, object: nil)
                    }
                }
            }
            else
            {
                print("Usuario nao encontrado")
                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userNotFound.rawValue, object: nil)
            }
        }
    }

    
    
    
    
    /** Funcao assincrona que executa o login no Parse
      * via Facebook (Parse é do Facebook);
      * A funcao nao retorna nenhuma condicao de retorno,
      * entretanto ao executar o login emite uma notificacao
      * contida em UserConditions
      */
    func loginFaceParse()
    {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user
            {
                if user.isNew
                {
                    print("Novo usuario cadastrado pelo Facebook")
                    user.setValue(100, forKey: "trustLevel")
                    user.save()
                    self.loadFaceInfo()
                }
                else
                {
                    print("usuario logado pelo Facebook")
                    
                    self.setUserName(user.valueForKey("username") as! String)
                    self.setFacebookID(user.valueForKey("facebookID") as! String)
                    self.setEmail(user.valueForKey("email") as! String)
                    self.setPassword(user.valueForKey("username") as! String)
                    self.setTrustLevel(user.valueForKey("trustLevel") as! Int)
                    self.setParseKey(user.valueForKey("objectId") as! String)
                    
                    let data = user.objectForKey("profileImage") as! PFFile
                    data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        let image = UIImage(data: data!)
                        self.setProfileImage(image!)
                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                    })
                }
            }
            else
            {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

    /** Funcao que é chamada logo apos o cliente efetuar
      * o login com o parse via Facebook, busca as
      * informacoes do perfil do facebook ativo como,
      * imagem de perfil, amigos etc
      */
    func loadFaceInfo()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let userName : NSString = result.valueForKey("name") as! NSString
                let userEmail : NSString = result.valueForKey("email") as! NSString
                let id = result.valueForKey("id") as! String

                let pictureURL = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"

                let URLRequest = NSURL(string: pictureURL)
                let URLRequestNeeded = NSURLRequest(URL: URLRequest!)

                NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse? ,data: NSData?, error: NSError?) -> Void in
                    if error == nil
                    {
                        let picture = PFFile(data: data!)
                        PFUser.currentUser()?.setValue(userName, forKey: "username")
                        PFUser.currentUser()?.setValue(userEmail, forKey: "email")
                        PFUser.currentUser()?.setValue(id, forKey: "facebookID")
                        PFUser.currentUser()!.setObject(picture, forKey: "profileImage")
                        PFUser.currentUser()!.save()
                        
                        let image = UIImage(data: data!)

                        self.setEmail(userEmail as String)
                        self.setProfileImage(image!)
                        self.setUserName(userName as String)
                        self.setFacebookID(id)

                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.incompleteRegister.rawValue, object: nil)
                    }
                    else
                    {
                        print("Error: \(error!.localizedDescription)")
                    }
                })
            }
        })
    }

    /** Funcao que deve ser chamada logo após ser efetuado
     * o login com o parse via facebook, essa funcao completa
     * as informacoes do usuario em relacao a senha e username.
     * Funcao essencial para o andamento do sistema.
     */
    func configUserFace(username: String, password: String)
    {
        let user = PFUser.currentUser()
        user?.setValue(username, forKey: "username")
        user?.setValue(password, forKey: "password")
        user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            
            let username = user?.valueForKey("username") as! String
            let email = user?.valueForKey("email") as! String
            let password = user?.valueForKey("password") as! String

            self.setUserName(username)
            self.setEmail(email)
            self.setPassword(password)
            
            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
        })
    }
    
    
    func getFaceContacts( callback : (metaContacts: [metaFaceContact]!) -> Void) -> Void {
        
        var contacts = [metaFaceContact]()
        var i = 0
        
        self.getFaceFriends { (friends:[metaFaceContact]!) -> Void in
            
            for friend in friends
            {
                let busca = PFUser.query()
                let id = friend.facebookID
                busca!.whereKey("facebookID", equalTo: id)
                busca!.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    print(objects?.count)
                    i++
                    if let objects = objects as? [PFObject]
                    {
                        if(objects.count > 0)
                        {
                            print("Amigo \(friend.faceUsername) esta no app")
                            let contact = metaFaceContact(facebookID: friend.facebookID, faceUsername: friend.faceUsername)
                            contacts.append(contact)
                        }
                    }
                    
                    if(friend.facebookID == friends.last?.facebookID)
                    {
                        print("retornando \(contacts.count) amigos")
                        callback(metaContacts: contacts)
                    }
                }
            }
            
            callback(metaContacts: contacts)
        }
    }
    
    
    /**
     * Funcao que cata os amigos no facebook
     * e retorna os mesmos em forma de metaContact
     */
    func getFaceFriends( callback : (friends: [metaFaceContact]!) -> Void) -> Void {

        var meta = [metaFaceContact]()

        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields":"name"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
        
            if error == nil
            {
                let results = result as! NSDictionary
                let data = results.objectForKey("data") as! [NSDictionary]
                
                for(var j = 0; j < data.count; j++)
                {
                    let name = data[j].valueForKey("name") as! String
                    let id = data[j].valueForKey("id") as! String
                    let c = metaFaceContact(facebookID: id, faceUsername: name)
                    print("Amigo \(name)")
                    meta.append(c)
                }
                callback(friends: meta)
            }
            else
            {
                print("Error Getting Friends \(error)");
                callback(friends: meta)
            }
        }
    }

    /** Funcao efetua o logout de um usuario!
      * Sua condicao de retorno é um par : booleano
      * e string, onde o primeiro indica se o logout
      * foi efeutaod corretamente e o segundo a descricao
      * de um possivel erro
      */
    func logOut() -> (done: Bool, error: String)
    {
        PFUser.logOut()
        self.setUserName("")
        self.setEmail("")
        self.setPassword("")
        self.setTrustLevel(-1)
        self.setFacebookID("")

        return (done: true, error: "")
    }



    /**
      * Funcao que pega a plist existente no main bundle, e copia a mesma
      * para o documents. Isso acontence pois a mesma (criada no bundle)
      * serve apenas de referencia e modelo. A que sera modificavel e
      * aplicavel vai permanecer no documents.
      */
    func initUserInformation()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as   NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("UserInfo.plist")
        let fileManager = NSFileManager.defaultManager()

        //Cria a plist na memoria do celular
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("UserInfo", ofType: "plist")
            {
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
    func getUserName() -> String!
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
    * Funcao que retorna o nome de usuario no Facebook
    * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
    * enquanto as de escrever utilizam o mutable dictionary
    **/
    func getFacebookID() -> String!
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
        
        let nome = content!.valueForKey("facebookID") as? String
        
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
    func getEmail() -> String
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

    
    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func getLastSync() -> String
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

    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func getTrustLevel() -> Int
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


    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func getPassword() -> String
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

    
    /**
    * Funcao que retorna o nome cadastro uma unica vez
    * do usuario do app
    * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
    * enquanto as de escrever utilizam o mutable dictionary
    **/
    func getBdKey() -> String
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
        
        let id = content!.valueForKey("bdKey") as? String
        
        if(id == nil)
        {
            return ""
        }
        
        return id!
    }

    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func getProfileImage() -> UIImage?
    {
        let userMail = self.getEmail()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("\(userMail)Photo") as String

        let image = UIImage(contentsOfFile: path)

        return image

    }

    
    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setLastSync(sync: String)
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

    
    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setUserName(name: String)
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
    
    
    /**
    * Funcao que retorna o nome cadastro uma unica vez
    * do usuario do app
    * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
    * enquanto as de escrever utilizam o mutable dictionary
    **/
    func setFacebookID(name: String)
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
        
        content!.setValue(name, forKey: "facebookID")
        content!.writeToFile(path, atomically: true)
    }

    
    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setEmail(email: String)
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


    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setPassword(password: String)
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


    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setTrustLevel(trustLevel: Int)
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

    
    func setParseKey(id: String)
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
        
        content!.setValue(id, forKey: "bdKey")
        content!.writeToFile(path, atomically: true)
        
    }

    /**
     * Funcao que retorna o nome cadastro uma unica vez
     * do usuario do app
     * OBS: Funcoes de leitura/obtencao utilizam nsdictionary
     * enquanto as de escrever utilizam o mutable dictionary
     **/
    func setProfileImage(image:UIImage)
    {
        let mailUser = self.getEmail()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documentsDirectory.stringByAppendingPathComponent("\(mailUser)Photo") as String

        UIImagePNGRepresentation(image)?.writeToFile(path, atomically: true)

    }

    
    /**
     * Funcao que retorna um booleano que indica
     * se um usuario esta logado ou nao. A condicao
     * é retornada através da verificacao se há
     * um username ativo na aplicaçao.
     * obs: Vale ressaltar que a funcao nao verifica
     * os demais valores, alem de username e senha.
     **/
    func isLoged() -> UserCondition
    {
        let username = self.getUserName()
        if(username != "")
        {
            let senha = self.getPassword()
            if(senha == "")
            {
                return UserCondition.incompleteRegister
            }
            else
            {
                return UserCondition.userLogged
            }
        }
        else
        {
        
            return UserCondition.userLoggedOut
        }
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

}

