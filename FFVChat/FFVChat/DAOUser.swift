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
import CoreData

class facebookContact
{
    var facebookId : String!
    
    var facebookName: String
    
    init(facebookId: String, facebookName: String)
    {
        self.facebookId = facebookId
        self.facebookName = facebookName
    }

}

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
    
    case termsUnaccepted = "termsUnaccepted"
    
    case contactsNotImported = "contactsNotImported"
    
    case notLinkedFacebook = "notLinkedFacebook"
    
    case unknowError = "unknowError"
    
    case password = "passwordChanged"
}

private let data : DAOUser = DAOUser()

class DAOUser
{
    var user : User!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init()
    {
        if(PFUser.currentUser() != nil && self.user == nil)
        {
            self.loginInApp(PFUser.currentUser()!.username!)
            if(self.user == nil)
            {
                print("Registro do usuario incompleto")
            }
        }
    }
    
    func setInstallation()
    {
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
        
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
                if(error.code == 202)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userAlreadyExist.rawValue, object: nil)
                }
                else if(error.code == 203)
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.emailInUse.rawValue, object: nil)
                }
                else
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.unknowError.rawValue, object: nil)
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
                let username = user!.username
                
                let loginApp = self.loginInApp(username!)
                
                //novo usuario localmente
                if(!loginApp)
                {
                    let email = user!.email!
                    let trustLevel = user!["trustLevel"] as! Int
                    let photo = user!["profileImage"] as! PFFile
                    let facebookID = user!["facebookID"] as? String
                    let gender = user!["gender"] as? String
                    
                    //TODO: verificar password em usuario
                    photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        if(data != nil)
                        {
                            let localUser = self.createUser(username!, email: email, trustLevel: trustLevel, profileImage: data!, facebookID: facebookID, gender: gender, password: password)
                            
                            self.user = localUser
                            self.setInstallation()
                            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                        }
                    })
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
                    user.saveEventually()
                    self.loadFaceInfo()
                }
                else
                {
                    print("usuario logado pelo Facebook")
                    let current = PFUser.currentUser()
                    print("current user: \(current)")
                    print("password from current user \(current?.password)")
                    
                    let username = user.valueForKey("username") as! String
                    let facebookId = user.valueForKey("facebookID") as? String
                    let email = user.valueForKey("email") as! String
                    let trustLevel = user.valueForKey("trustLevel") as! Int
                    let gender = user.valueForKey("gender") as? String
                    
                    let data = user.objectForKey("profileImage") as! PFFile
                    data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        
                        if(data != nil)
                        {
                            if(!self.loginInApp(username))
                            {
                                let localUser = self.createUser(username, email: email, trustLevel: trustLevel, profileImage: data!, facebookID: facebookId, gender: gender, password: "000000")
                                self.user = localUser
                            }
                            
                            self.user.trustLevel = trustLevel
                            self.user.facebookID = facebookId
                            self.save()
                            
                        }
                        self.setInstallation()
                        if(self.isValidUsername(username))
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                        }
                        else
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.incompleteRegister.rawValue, object: nil)
                        }
                    })
                }
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.loginCanceled.rawValue, object: nil)
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    
    func linkParseAccountWithFacebook()
    {
        if(self.user != nil)
        {
            let username = self.user.username
            let password = self.user.password
            
            PFUser.currentUser()?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if(success)
                {
                    PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"]) {
                        (user: PFUser?, error: NSError?) -> Void in
                        
                        if let user = user
                        {
                            //Se o usuario for novo, carrega as informacoes
                            //do facebook, é atribui como username e senha
                            //os mesmos salvos a cima.
                            if user.isNew
                            {
                                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,hometown,relationship_status,work,birthday,education"])
                                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                                    
                                    if ((error) != nil)
                                    {
                                        // Process error
                                        print("Error: \(error)")
                                    }
                                    else
                                    {
                                        print("resultado de logar-se pelo face: \(result)")
                                        let email : NSString = result.valueForKey("email") as! NSString
                                        let id = result.valueForKey("id") as! String
                                        let gender = result.valueForKey("gender") as! String
                                        
                                        let pictureURL = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"
                                        
                                        let URLRequest = NSURL(string: pictureURL)
                                        let URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                                        
                                        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse? ,data: NSData?, error: NSError?) -> Void in
                                            if error == nil
                                            {
                                                let picture = PFFile(data: data!)
                                                PFUser.currentUser()?.setValue(username, forKey: "username")
                                                PFUser.currentUser()?.setValue(email, forKey: "email")
                                                PFUser.currentUser()?.setValue(id, forKey: "facebookID")
                                                PFUser.currentUser()!.setObject(picture, forKey: "profileImage")
                                                PFUser.currentUser()?.setValue(100, forKey: "trustLevel")
                                                PFUser.currentUser()?.setValue(gender, forKey: "gender")
                                                PFUser.currentUser()?.setValue(password, forKey: "password")
                                                PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                                    
                                                    if(success)
                                                    {
                                                        print("informacoes atualizadas no parse")
                                                        let user = User.createInManagedObjectContext(self.managedObjectContext, username: username, email: PFUser.currentUser()!.email!, profileImage: data!, trustLevel: 100, facebookID: id, gender: gender, password: password)
                                                        self.save()
                                                        self.user = user
                                                        
                                                        self.setInstallation()
                                                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                                                    }
                                                    else
                                                    {
                                                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.unknowError.rawValue, object: nil)
                                                    }
                                                })
                                            }
                                            else
                                            {
                                                print("Error: \(error!.localizedDescription)")
                                            }
                                        })
                                    }
                                })
                            }
                            //Caso nao seja novo, apaga o usuario novo criado
                            //e simplesmente loga com o antigo.
                            else
                            {
                                print("usuario logado pelo Facebook")
                                let current = PFUser.currentUser()
                                print("current user: \(current)")
                                
                                let username = user.valueForKey("username") as! String
                                let facebookId = user.valueForKey("facebookID") as? String
                                let email = user.valueForKey("email") as! String
                                let trustLevel = user.valueForKey("trustLevel") as! Int
                                let gender = user.valueForKey("gender") as? String
                                
                                let data = user.objectForKey("profileImage") as! PFFile
                                data.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                                    
                                    if(data != nil)
                                    {
                                        if(!self.loginInApp(username))
                                        {
                                            let localUser = self.createUser(username, email: email, trustLevel: trustLevel, profileImage: data!, facebookID: facebookId, gender: gender, password: password)
                                            self.user = localUser
                                        }
                                        
                                        self.user.trustLevel = trustLevel
                                        self.user.facebookID = facebookId
                                        self.save()
                                        
                                    }
                                    self.setInstallation()
                                    if(self.isValidUsername(username))
                                    {
                                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)
                                    }
                                    else
                                    {
                                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.incompleteRegister.rawValue, object: nil)
                                    }
                                })
                            }
                        }
                        else
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.unknowError.rawValue, object: nil)
                        }
                    }
                }
                else
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.unknowError.rawValue, object: nil)
                }
            })
        }
    }
    

    /** Funcao que é chamada logo apos o cliente efetuar
      * o login com o parse via Facebook, busca as
      * informacoes do perfil do facebook ativo como,
      * imagem de perfil, amigos etc
      */
    func loadFaceInfo()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,hometown,relationship_status,work,birthday,education"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("resultado de logar-se pelo face: \(result)")
                let username : NSString = result.valueForKey("name") as! NSString
                let email : NSString = result.valueForKey("email") as! NSString
                let id = result.valueForKey("id") as! String
                let gender = result.valueForKey("gender") as! String

                let pictureURL = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"

                let URLRequest = NSURL(string: pictureURL)
                let URLRequestNeeded = NSURLRequest(URL: URLRequest!)

                NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse? ,data: NSData?, error: NSError?) -> Void in
                    if error == nil
                    {
                        let picture = PFFile(data: data!)
                        PFUser.currentUser()?.setValue(username, forKey: "username")
                        PFUser.currentUser()?.setValue(email, forKey: "email")
                        PFUser.currentUser()?.setValue(id, forKey: "facebookID")
                        PFUser.currentUser()!.setObject(picture, forKey: "profileImage")
                        PFUser.currentUser()?.setValue(100, forKey: "trustLevel")
                        PFUser.currentUser()?.setValue(gender, forKey: "gender")
                        PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            
                            if(success)
                            {
                                print("informacoes atualizadas no parse")
                                let user = User.createInManagedObjectContext(self.managedObjectContext, username: "tempUser", email: PFUser.currentUser()!.email!, profileImage: data!, trustLevel: 100, facebookID: id, gender: gender, password: "000000")
                                self.save()
                                self.user = user
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.incompleteRegister.rawValue, object: nil)
                            }
                            else
                            {
                                NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.unknowError.rawValue, object: nil)
                            }
                            
                            
                            
                        })
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
            let facebookID = user?.valueForKey("facebookID") as! String
            let photo = user?.objectForKey("profileImage") as! PFFile
            let gender = user?.valueForKey("gender") as? String
            
            photo.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                
                if(!self.loginInApp(username))
                {
                    if(data != nil)
                    {
                        let localUser = self.createUser(username, email: email, trustLevel: 100, profileImage: data!, facebookID: facebookID, gender: gender, password: password)
                        self.user = localUser
                        self.save()
                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.userLogged.rawValue, object: nil)

                    }
                    else
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName(UserCondition.loginCanceled.rawValue, object: nil)
                    }
                }
                
            })
        })
    }
    
    
    /**
     * Funcao que cata os amigos no facebook
     * e retorna os mesmos em forma de metaContact
     */
    func getFaceFriends( callback : (friends: [facebookContact]!) -> Void) -> Void {

        var meta = [facebookContact]()

        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields":"name"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
        
            if error == nil
            {
//                print(result)
                let results = result as! NSDictionary
                let data = results.objectForKey("data") as! [NSDictionary]
                
                for amigo in data
                {
                    let name = amigo.valueForKey("name") as! String
                    let id = amigo.valueForKey("id") as! String
                    let c = facebookContact(facebookId: id, facebookName: name)
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
    
    func createUser(username: String, email: String, trustLevel: Int, profileImage: NSData, facebookID: String?, gender: String?, password: String) -> User
    {
        let user = User.createInManagedObjectContext(self.managedObjectContext, username: username, email: email, profileImage: profileImage, trustLevel: trustLevel, facebookID: facebookID, gender: gender, password: password)
        
        self.save()
        
        return user
        
    }

    /**
     * Atribui ao self.user do DAOUser um usuario, ou seja
     * efetua o login de uma conta de usuario previamente cadastrada
     * no app, dado um username. 
     * Retorna :
     *
     * true - caso o usuario ja exista no app e o login
     *              tenha se dado com sucessp
     *              
     * false - caso o usuario passado como paramentro
     *              nao exista.
     *
     * Obs: Essa funcao serve apenas para parear o usuario corrente
     * logado no servidor, é apenas um registro local e constante
     * do mesmo, para que as informacoes necessarias do mesmo sejam
     * acessadas de forma instantenea sem a ncessidade de uma conexão
     * com o banco de dados
     */
    func loginInApp(username: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "User")
        
        let predicate = NSPredicate(format: "username == %@", username)
        
        request.predicate = predicate
        
        do { let result = try self.managedObjectContext.executeFetchRequest(request) as! [User]
        
            if(result.count > 0)
            {
                
                print("logando como \(result.first)")
                self.user = result.first!
                return true
            }
            else
            {
                print("Nao foram encontrados usuarios no sistema")
                return false
            }
        }
        catch
        {
            print("Erro inesperado ao procurar usuarios no sistema")
            return false
        }
    }
    
    
    func getTempUser() -> User?
    {
        let request = NSFetchRequest(entityName: "User")
        
        let predicate = NSPredicate(format: "username == %@", "tempUser")
        
        request.predicate = predicate
        
        let result = try! self.managedObjectContext.executeFetchRequest(request) as! [User]
    
        return result.first
    }
    
    /** Funcao efetua o logout de um usuario!
      * Sua condicao de retorno é um par : booleano
      * e string, onde o primeiro indica se o logout
      * foi efeutaod corretamente e o segundo a descricao
      * de um possivel erro
      */
    func logOut() -> (done: Bool, error: String?)
    {
        self.user = nil
        PFUser.logOut()
        return (done: true, error: nil)
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
        if(PFUser.currentUser() == nil)
        {
            return UserCondition.userLoggedOut
        }
        else if(PFUser.currentUser() != nil && self.user == nil)
        {
            self.user = self.getTempUser()
            return UserCondition.incompleteRegister
        }
        else
        {
            if(AppStateData.sharedInstance.termsOfUseAccepted())
            {
                if(AppStateData.sharedInstance.contactsImported())
                {
                    return UserCondition.userLogged
                }
                else
                {
                    if(DAOUser.sharedInstance.getFacebookId() != nil)
                    {
                        return UserCondition.contactsNotImported
                    }
                    else
                    {
                        return UserCondition.notLinkedFacebook
                    }
                }
            }
            else
            {
                return UserCondition.termsUnaccepted
            }
        }
    }
    
    
    
    func getProfileImage() -> UIImage
    {
        return UIImage(data: self.user.profileImage!)!
    }
    
    func getUsername() -> String
    {
        return PFUser.currentUser()!.username!
    }
    
    func getEmail() -> String
    {
        return self.user.email
    }
    
    func getTrustLevel() -> Int
    {
        return Int(self.user.trustLevel!)
    }
    
    func getFacebookId() -> String?
    {
        return self.user.facebookID
    }
    
    func getGender() -> String?
    {
        return self.user.gender
    }

    func checkPassword(password: String) -> Bool
    {
        return (password == self.user.password)
    }
    
    //AJUSTES DO USUARIO
    
    func decreaseTrustLevel()
    {
        self.user.trustLevel  = Int(self.user.trustLevel) - 5
        self.save()
        DAOParse.decreaseTrustLevel()
    }
    
    func changePassword(password: String)
    {
        PFUser.currentUser()?.setValue(password, forKey: "password")
        
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if(success)
            {
                self.user.password = password
                self.save()
                NSNotificationCenter.defaultCenter().postNotificationName("passwordChanged", object: nil)
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotificationName("wrongPassword", object: nil)
            }
        })
    }
    
    
    func changeProfilePicture(image: UIImage)
    {
        let data = image.mediumQualityJPEGNSData
        
        PFUser.currentUser()!["profileImage"] = PFFile(data: data)
        PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Imagem salva com \(success) e erro: \(error)")
        }
        
        self.user.profileImage = data
        self.save()
    }
    
    
    //Fim dos ajustes do usuario
    
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    func isValidUsername(username: String) -> Bool
    {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpressionOptions())
        if regex.firstMatchInString(username, options: NSMatchingOptions(), range:NSMakeRange(0, username.characters.count)) != nil {
            print("could not handle special characters")
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func checkCorrectEmail(email: String) -> Bool
    {
        if(email == PFUser.currentUser()?.email)
        {
            return true
        }
        else
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

