//
//  DAOPostgres.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift


private let data: DAOPostgres = DAOPostgres()

private let baseUrl = "http://54.233.109.25/phps"

class DAOPostgres : NSObject
{
    var refresherChat : NSTimer!
    
    var refresher : NSTimer!
    
    var observer : NSTimer!
    
    // URLs
    /** Envia mensagem */
    let messageUrl_send = "\(baseUrl)/Messages_send.php"
    
    /** Marca uma mensagem como recebida no banco de dados */
    let messageUrl_received = "\(baseUrl)/Messages_setReceived.php"
    
    /** Marca uma mensagem como vista no banco de dados */
    let messageUrl_seen = "\(baseUrl)/Messages_setSeen.php"
    
    /** Marca uma mensagem como deletada no banco de dados */
    let messageUrl_deleted = "\(baseUrl)/Messages_setDeleted.php"
    
    /** Deleta uma mensagem no banco de dados */
    let messageUrl_delete = "\(baseUrl)/Messages_delete.php"
    
    /** Busca as mensagens nao lidas no banco */
    let messageUrl_getUnread = "\(baseUrl)/Messages_getUnread.php"
    
    /** Busca as mensagens nao lidas ou deletadas no banco */
    let messageUrl_getUnreadAndDeleted = "\(baseUrl)/Messages_getUnreadAndDeleted.php"
    
    /** Busca as mensagens ja deletadas no banco */
    let messageUrl_getDeleted = "\(baseUrl)/Messages_getDeleted.php"
    
    /** Envia uma imagem ao banco de dados*/
    let imageUrl_upload = "\(baseUrl)/Images_upload.php"
    
    /** Busca uma imagem ao banco de dados*/
    let imageUrl_download = "\(baseUrl)/Images_download.php"
    
    /** Busca todos os gifs disponiveis no banco de dados */
    let gifsUrl_getAll = "\(baseUrl)/Gifs_getAll.php"
    
    let fr_getPendentes = "\(baseUrl)/FriendRequests_getPendentes.php"

    let fr_getAceitos = "\(baseUrl)/FriendRequests_getAceitos.php"
    
    let fr_delete = "\(baseUrl)/FriendRequests_delete.php"
    
    let fr_setAceito = "\(baseUrl)/FriendRequests_setAceito.php"
    
    let fr_send = "\(baseUrl)/FriendRequests_send.php"
    
    let fr_user = "\(baseUrl)/FriendRequests_forUser.php"
    
    
    override init()
    {
        super.init()
    }
    
    class var sharedInstance : DAOPostgres
    {
        return data
    }
    
    
    /**
     * Funcao gostosinha que carrega as mensagens nao lidas do banco
     * e retorna para o usuario. A cada mensagem carregada com sucesso
     * o registro é mudado para "recebido" no banco.
     */
    func getUnreadMessages()
    {
        print("refreshing messages...")
        let parameters : [String:AnyObject]!  = ["target": EncryptTools.encryptUsername(DAOUser.sharedInstance.getUsername())]
        
        Alamofire.request(.POST, self.messageUrl_getUnread, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let id = result["id"] as! String
                        let typeString = result["type"] as! String
                        let type = ContentType(rawValue: typeString)!
                        let sender = result["sender"] as! String
                        let key = result["contentkey"] as? String
                        let lifeTime = (result["lifetime"] as! NSString).integerValue
                        let date = result["sentdate"] as! String
                        let sentDate = self.string2nsdate(date)
                        
                        let decSender = EncryptTools.getUsernameFromEncrpted(sender)
                        
                        if(decSender != nil)
                        {
                            switch type
                            {
                                
                            case .Text:
                                
                                let text = result["text"] as! String
                                
                                let decText = EncryptTools.decryptText(text)
                                
                                if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, text: decText, sentDate: sentDate, lifeTime: lifeTime))
                                {
                                    self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                }
                                
                            case .Image:
                                
                                if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Image))
                                {
                                    self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                }
                                
                            case .Audio:
                                
                                if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Audio))
                                {
                                    self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                }
                                
                            case .Gif:
                                
                                if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Gif))
                                {
                                    self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                }
                                
                            default:
                                
                                print("Erro ao encontrar tipo do arquivo recebido!")
                                
                            }
                        }
                    }
                }
        }
        
    }
    
    
    /**
     * Checa no banco de dados as mensagens que ja foram marcadas
     * como deletadas.
     */
    func checkForDeletedMessages()
    {
        let parameters : [String:AnyObject]!  = ["sender": EncryptTools.encryptUsername(DAOUser.sharedInstance.getUsername())]
        
        Alamofire.request(.POST, self.messageUrl_getDeleted, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let id = result["id"] as! String
                        DAOMessages.sharedInstance.deleteMessage(id, atualizaNoBanco: false)
                    }
                }
        }
    }
    
    /**
     * Funcao responsavel por pesquisar mensagens endereçadas
     * ao usuario atual com o status de 'sent' (enviadas) ou 
     * deletada.
     * No caso de serem mensagens nao lidas, enviadas, o controlador
     * adiciona as mesmas no armazenamento local e as marca como
     * vistas no banco.
     * Caso sejam mensagens ja deletadas, o controlador as deleta.
     */
    func getUnreadAndDeletedMessages()
    {
        print("refreshing unread and deleted messages...")
        let parameters : [String:AnyObject]!  = ["target": EncryptTools.encryptUsername(DAOUser.sharedInstance.getUsername())]
        
        Alamofire.request(.POST, self.messageUrl_getUnreadAndDeleted, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value
                {
                    for result in results as! NSArray
                    {
                        let id = result["id"] as! String
                        let status = result["status"] as! String
                        
                        if(status == "sent")
                        {
                            let typeString = result["type"] as! String
                            let type = ContentType(rawValue: typeString)!
                            let sender = result["sender"] as! String
                            let key = result["contentkey"] as? String
                            let lifeTime = (result["lifetime"] as! NSString).integerValue
                            let date = result["sentdate"] as! String
                            let sentDate = self.string2nsdate(date)
                            
                            let decSender = EncryptTools.getUsernameFromEncrpted(sender)
                            
                            if(decSender != nil)
                            {
                                switch type
                                {
                                    
                                case .Text:
                                    
                                    let text = result["text"] as! String
                                    
                                    let decText = EncryptTools.decryptText(text)
                                    
                                    if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, text: decText, sentDate: sentDate, lifeTime: lifeTime))
                                    {
                                        self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                    }
                                    
                                case .Image:
                                    
                                    if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Image))
                                    {
                                        self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                    }
                                    
                                case .Audio:
                                    
                                    if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Audio))
                                    {
                                        self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                    }
                                    
                                case .Gif:
                                    
                                    if(DAOMessages.sharedInstance.addReceivedMessage(id, sender: decSender!, contentKey: key!, sentDate: sentDate, lifeTime: lifeTime, type: ContentType.Gif))
                                    {
                                        self.setMessageReceived(DAOMessages.sharedInstance.lastMessage.id)
                                    }
                                    
                                default:
                                    
                                    print("Erro ao encontrar tipo do arquivo recebido!")
                                    
                                }
                            }
                        }
                        else if(status == "deleted")
                        {
                            DAOMessages.sharedInstance.deleteMessage(id, atualizaNoBanco: false)
                            self.deleteDeletedMessage(id)
                        }
                    }
                }
        }

    }

    
    func checkForUnacceptedFriendRequests(callback: (friendRequests: [FriendRequest]) -> Void)
    {
        let parameters : [String:AnyObject]!  = ["target": DAOUser.sharedInstance.getUsername()]
        var requests = [FriendRequest]()
        
        Alamofire.request(.POST, self.fr_getPendentes, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let sender = result["sender"] as! String
                        let target = result["target"] as! String
                        let id = result["id"] as! String
                        
                        let fr = FriendRequest(id: id, sender: sender, target: target)
                        requests.append(fr)
                    }
                    
                    callback(friendRequests: requests)
                }
        }
        
    }
    
    
    func checkForAcceptedFriendRequests(callback: (friendRequests: [FriendRequest]) -> Void)
    {
        let parameters : [String:AnyObject]!  = ["sender": DAOUser.sharedInstance.getUsername()]
        var requests = [FriendRequest]()
        
        Alamofire.request(.POST, self.fr_getAceitos, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let sender = result["sender"] as! String
                        let target = result["target"] as! String
                        let id = result["id"] as! String
                        
                        let fr = FriendRequest(id: id, sender: sender, target: target)
                        requests.append(fr)
                    }
                    callback(friendRequests: requests)
                }
        }
        
    }
    
    func checkForUsernameFriendRequests(username: String, callback: (exist: Bool) -> Void)
    {
        let parameters : [String:AnyObject]!  = ["sender": DAOUser.sharedInstance.getUsername(), "target": username]
        
        Alamofire.request(.POST, self.fr_user, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    if((results as! NSArray).count == 0)
                    {
                        callback(exist: false)
                    }
                    else
                    {
                        callback(exist: true)
                    }
                }
        }
        
    }
    
    func setRequestAccepted(id: String, callback: (success: Bool) -> Void)
    {
        let parameters : [String:AnyObject]! = ["id": id, "updatedAt":NSDate()]
        
        Alamofire.request(.POST, self.fr_setAceito, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    callback(success: false)
                }
                else
                {
                    print("Requisicao de amizade aceita com sucesso!")
                    callback(success: true)
                }
        }
    }
    
    
    func deleteFriendRequest(id: String)
    {
        let parameters : [String:AnyObject]! = ["id": id]
        
        Alamofire.request(.POST, self.fr_delete, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {

                }
                else
                {
                    print("Requisicao de amizade excluida com sucesso!")
                }
        }
    }
    
    
    func sendFriendRequest(id: String, username: String)
    {
        let parameters : [String:AnyObject]!  = ["id":id, "sender": DAOUser.sharedInstance.getUsername(), "target": username, "createdAt": NSDate()]
        
        Alamofire.request(.POST, self.fr_send, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                }
                else
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationController.center.friendRequested.name, object: nil)
                    print("Requisicao de amizade enviada com sucesso!")
                }
        }
    }
    
    /**
     * Funcao responsavel por enviar oa banco de dados uma nova mensagem.
     * É valido ressaltar que essa mesma funcao cuida do estado de cripto-
     * grafia, ou seja, criptografa a mensagem dadas as regras de criptografia
     * da aplicacao
     */
    func sendTextMessage(id: String, username: String, lifeTime: Int, text: String, sentDate: NSDate)
    {
        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(DAOUser.sharedInstance.getUsername()), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "text": EncryptTools.encryptText(text, contact: username), "lifeTime": lifeTime, "type": ContentType.Text.rawValue]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tratar falha no envio, por enquanto vou excluir
//                    DAOMessages.sharedInstance.deleteMessage(id)
                    DAOMessages.sharedInstance.setMessageError(id)
                }
                else
                {
                    DAOMessages.sharedInstance.setMessageSent(id)
                    print("Mensagem evnaida com sucesso!")
                }
        }
    }
    
    
    func sendImageMessage(id: String, username: String, lifeTime: Int, contentKey: String, sentDate: NSDate)
    {
        let me = DAOUser.sharedInstance.getUsername()

        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(me), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "lifeTime": lifeTime, "type": ContentType.Image.rawValue, "contentKey": contentKey]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tratar falha no envio, por enquanto vou excluir
                }
                else
                {
                    //Jogando essa funcao para o final do carregamento da imagem
                    DAOMessages.sharedInstance.setMessageSent(id)
                    print("Mensagem evnaida com sucesso!")
                }
        }
    }
    
    
    func sendAudioMessage(id: String, username: String, lifeTime: Int, contentKey: String, sentDate: NSDate)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(me), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "lifeTime": lifeTime, "type": ContentType.Audio.rawValue, "contentKey": contentKey]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tratar falha no envio, por enquanto vou excluir
                }
                else
                {
                    DAOMessages.sharedInstance.setMessageSent(id)
                    print("Mensagem enviada com sucesso!")
                }
        }
    }
    
    
    func sendGifMessage(id: String, username: String, lifeTime: Int, gifName: String, sentDate: NSDate)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(me), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "lifeTime": lifeTime, "type": ContentType.Gif.rawValue, "contentKey": gifName]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tratar falha no envio, por enquanto vou excluir
                }
                else
                {
                    DAOMessages.sharedInstance.setMessageSent(id)
                    print("Mensagem evnaida com sucesso!")
                }
        }
    }
    
    
    func setMessageReceived(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_received, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tenta de novo, parça
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1)) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.setMessageReceived(messageID)
                    }
                }
                else
                {
                    print("Mensagem marcada como recebida com sucesso!")
                }
        }
    }
    
    func setMessageSeen(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_seen, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tenta de novo, parça
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1)) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.setMessageSeen(messageID)
                    }
                }
                else
                {
                    print("Mensagem marcada como vista com sucesso!")
                }
        }
    }
    
    func setDeletedMessage(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_deleted, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tenta de novo, parça
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1)) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.setDeletedMessage(messageID)
                    }
                }
                else
                {
                    print("Mensagem marcada como deletada com sucesso!")
                }
        }
    }
    
    func deleteDeletedMessage(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_delete, parameters: parameters)
            .responseJSON { response in
                
                if(response.result.isFailure)
                {
                    //Tenta de novo, parça
                    //                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1)) * Double(NSEC_PER_SEC)))
                    //                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                    //                        self.setMessageReceived(messageID)
                    //                    }
                }
                else
                {
                    print("Mensagem excluida com sucesso!")
                }
        }
    }
    
    func string2nsdate(str: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return dateFormatter.dateFromString(str) as NSDate!
    }
    
    func string2nsdateMini(str: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return dateFormatter.dateFromString(str) as NSDate!
    }
    
    /***  REFRESHER  ***/
    
    func startRefreshing()
    {
        self.stopObserve()
        
        self.refresher?.invalidate()
        self.refresher = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refresh", userInfo: nil, repeats: true)
    }
    
    func stopRefreshing()
    {
        print("Terminando de atualizar as mensagens instantaneamente")
        self.refresher?.invalidate()
    }
    
    func refresh()
    {
        self.getUnreadAndDeletedMessages()
    }
    
    
    /*** OBSERVADOR **/
    
    func startObserve()
    {
        self.stopRefreshing()
        
        self.observer?.invalidate()
        self.observer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "observe", userInfo: nil, repeats: true)
    }
    
    func stopObserve()
    {
        print("Terminando de observar o banco")
        self.observer?.invalidate()
    }
    
    func observe()
    {
        DAOFriendRequests.sharedInstance.reloadInfos()
    }
    
    
    //Gifs
    func getAllGifsName(callback:(gifs: [String]) -> Void)
    {
        var gifs = [String]()
        
        Alamofire.request(.POST, self.gifsUrl_getAll, parameters: nil)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let name = result["name"] as! String

                        gifs.append(name)
                    }
                    
                    callback(gifs: gifs)
                }
        }
        
    }
    
    
    //Aux Functions. ************************************************
    
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    func separateStringArray(string: String) -> [String]
    {
        var array = [String]()
        
        let stringLenght = string.characters.count
        
        let hashtags = (string as NSString).substringWithRange(NSMakeRange(1, stringLenght-2))
        
        let parts = hashtags.componentsSeparatedByString(",").count
        
        for i in 0...(parts-1)
        {
            array.append(hashtags.componentsSeparatedByString(",")[i])
        }
        
        return array
    }
}


