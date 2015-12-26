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
    
    var refresherContact : NSTimer!
    
    var deleteOldMessages : NSTimer!
    
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
    
    /** Busca as mensagens ja deletadas no banco */
    let messageUrl_getDeleted = "\(baseUrl)/Messages_getDeleted.php"
    
    /** Envia uma imagem ao banco de dados*/
    let imageUrl_upload = "\(baseUrl)/Images_upload.php"
    
    /** Busca uma imagem ao banco de dados*/
    let imageUrl_download = "\(baseUrl)/Images_download.php"
    
    /** Busca todos os gifs disponiveis no banco de dados */
    let gifsUrl_getAll = "\(baseUrl)/Gifs_getAll.php"
    
    
    
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
                                
                                print("recebeu audio")
                                
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
    
    
    func checkForDeletedMessages()
    {
        let parameters : [String:AnyObject]!  = ["sender": EncryptTools.encryptUsername(DAOUser.sharedInstance.getUsername())]
        
        Alamofire.request(.POST, self.messageUrl_getDeleted, parameters: parameters)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        let id = result["id"] as! String
                        DAOMessages.sharedInstance.deleteMessage(id)
                    }
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
                print(response)
        }
    }
    
    func sendImageMessage(id: String, username: String, lifeTime: Int, contentKey: String ,image: UIImage, filter: ImageFilter, sentDate: NSDate)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let params = ["imageKey": contentKey, "filter": filter.rawValue]

        // example image data
        let imageData = image.mediumQualityJPEGNSData
        
        // CREATE AND SEND REQUEST ----------
        
        let urlRequest = urlRequestWithComponents(self.imageUrl_upload, parameters: params, imageData: imageData)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseString { response in
                print("RESPONSE \(response)")
        }
        
        
        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(me), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "lifeTime": lifeTime, "type": ContentType.Image.rawValue, "contentKey": contentKey]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    func sendGifMessage(id: String, username: String, lifeTime: Int, gifName: String, sentDate: NSDate)
    {
        let me = DAOUser.sharedInstance.getUsername()
        
        let parameters : [String:AnyObject]!  = ["id":id, "sender": EncryptTools.encryptUsername(me), "target": EncryptTools.encryptUsername(username), "sentDate": sentDate, "lifeTime": lifeTime, "type": ContentType.Gif.rawValue, "contentKey": gifName]
        
        Alamofire.request(.POST, self.messageUrl_send, parameters: parameters)
            .responseJSON { response in
                print(response)
        }
    }
    
    
    func setMessageReceived(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_received, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    func setMessageSeen(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_seen, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    func setDeletedMessage(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_deleted, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    func deleteDeletedMessage(messageID: String)
    {
        let parameters : [String:AnyObject]! = ["id": messageID]
        
        Alamofire.request(.POST, self.messageUrl_delete, parameters: parameters)
            .responseJSON { response in
                print(response.result.value)
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
    
    func stopRefreshing()
    {
        self.refresherChat?.invalidate()
        self.deleteOldMessages?.invalidate()
    }
    
    func startRefreshing()
    {
        self.stopObserve()
        self.deleteOldMessages?.invalidate()
        self.refresherChat?.invalidate()
        
        self.refresherChat = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
        self.deleteOldMessages = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkForDeletedMessages", userInfo: nil, repeats: true)
    }
    
    func startObserve()
    {
        self.stopRefreshing()
        self.refresherContact?.invalidate()
        self.deleteOldMessages?.invalidate()
        self.deleteOldMessages = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "checkForDeletedMessages", userInfo: nil, repeats: true)
        self.refresherContact = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "getUnreadMessages", userInfo: nil, repeats: true)
    }
    
    func stopObserve()
    {
        self.refresherContact?.invalidate()
        self.deleteOldMessages?.invalidate()
    }
    
    
    //Gifs
    func addAllGifs()
    {
        Alamofire.request(.POST, self.gifsUrl_getAll, parameters: nil)
            .responseJSON { response in
                
                if let results = response.result.value {
                    
                    for result in results as! NSArray
                    {
                        print(result)
                        
                        let name = result["name"] as! String
                        let hashtags = result["hashtags"] as! String
                        let launcheddate = result["launcheddate"] as! String
                        let url = result["url"] as! String
                        
                        let hash = self.separateStringArray(hashtags)
                        let date = self.string2nsdateMini(launcheddate)
                        
                        DAOContents.sharedInstance.addGif(name, url: url, hashtags: hash, launchedDate: date)
                    }
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
        
        print(hashtags)
        
        let parts = hashtags.componentsSeparatedByString(",").count
        
        for i in 0...(parts-1)
        {
            array.append(hashtags.componentsSeparatedByString(",")[i])
        }
        
        return array
    }
}


