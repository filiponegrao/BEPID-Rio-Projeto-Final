//
//  DAOMessages.swift
//  FFVChat
//
//  Created by Filipo Negrao on 23/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data = DAOMessages()


class DAOMessages : NSObject
{
    var currentMessage : Message?
    
    var lastMessage : Message!
    
    var lastSentMessage : Message!
    
    var inExecution: Bool = false
    
    var delayForPush : NSTimer!
    
    var delay: Bool = false
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    /** 
     * Variavel responsavel por armazenar todas as ordens
     * de exclusao de mensagens apos algum tempo.
     * É um dictionary, onde:
     * 
     * - Chave: [message sentDate] obtido pela funcao
     *          Optimization.getBigStringFromDate()
     *          passando como parametro a sentDate de uma
     *          mensagem.
     *
     * - Conteudo: [NSTimer] um timer para deletar a mensagem
     *              com a sentDate igual a passada como parametro
     *              na chave. A funcao chamada apos o termino
     *              da contagem é a timesUpMessage.
     */
//    var timeBomb = NSMutableDictionary()
    
    override init()
    {
        super.init()
        self.currentMessage = nil
    }
    
    class var sharedInstance : DAOMessages
    {
        return data
    }
    
    /*************************************************
     *                                               *
     *   SENDING AND RECEVING MESSAGES FUNCTIONS     *
     *                                               *
     *************************************************/
    
    /**
     * Funcao responsavel por criar uma chave única para mensagens.
     *
     */
    func createMessageKey(username: String, date: NSDate) -> String
    {
        let cleanDate = Optimization.removeWhiteSpaces("\(date)")
        let names = DAOUser.sharedInstance.getUsername() + username
        
        let rawKey = names + cleanDate
        let key = EncryptTools.encKey(rawKey)
        
        return key
    }
    
    /**
     * Funcao responsavel por criar uma chave única para um conteudo.
     */
    func createContentKey(messageKey: String) -> String
    {
        let contentKey = "Content_" + messageKey
        
        return contentKey
    }
    
    
    func checkForOldMessages()
    {
        let doneMessages = TimeBomb.sharedInstance.doneTimers()
        for message in doneMessages
        {
            self.deleteMessage(message, atualizaNoBanco: true)
        }
        
        let oldMessages = TimeBomb.sharedInstance.checkForOldTimers()
        
        print(oldMessages)
        
        for oldmessage in oldMessages
        {
            let message = self.messageForId(oldmessage)
            if(message != nil)
            {
                let seenDate = TimeBomb.sharedInstance.getSeenDateById(oldmessage)
                let calendar = NSCalendar.currentCalendar()
                let timeElapsed = calendar.components(.Second, fromDate: seenDate!, toDate: NSDate(), options: [])
                
                let timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(Int(message!.lifeTime) - timeElapsed.second), target: self, selector: "receiveTimesUpNotification:", userInfo: ["id":oldmessage], repeats: false)
            }
        }
    }
    
    /**
     * Sending message function.
     * Type: TEXT
     *
     * Obs: Calls a extern function, from some Data access 
     *      from or to net. In this functions above, we just
     *      add this message to the CoreData, and using the
     *      extern function we send this message to the DB
     */
    
    func sendMessage(username: String, text: String) -> Message
    {
        print("registrando no banco...")
        let now = NSDate()
        let id = self.createMessageKey(username, date: now)
        
        let time = UserLayoutSettings.sharedInstance.getCurrentSecondsTextLifespan()
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: time, type: .Text, contentKey: nil, text: text, status: messageStatus.Ready.rawValue)
        
        self.save()
        
        NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.messageReady(id), object: nil, userInfo: nil)
        
        DAOPostgres.sharedInstance.sendTextMessage(id, username: username, lifeTime: time, text: text, sentDate: now)
        
        //Push notification
        if(!self.delay)
        {
            self.delay = true
            DAOParse.pushMessageNotification(username, text: text)
            self.delayForPush?.invalidate()
            self.delayForPush = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "turnOffDelayForPush:", userInfo: nil, repeats: false)
        }
        
        self.lastSentMessage = message
        
        return message
    }
    
    /**
     * Sending message function.
     * Type: Image
     *
     * Obs: Calls a extern function, from some Data access
     *      from or to net. In this functions above, we just
     *      add this message to the CoreData, and using the
     *      extern function we send this message to the DB
     */
    func sendMessage(username: String, image: UIImage, lifeTime: Int, filter: ImageFilter) -> Message
    {
        let now = NSDate()
        
        let id = self.createMessageKey(username, date: now)
        let key = self.createContentKey(id)
        
        DAOContents.sharedInstance.addImage(key, data: image.mediumQualityJPEGNSData, filter: filter, preview: image.lowestQualityJPEGNSData)
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: lifeTime, type: .Image, contentKey: key, text: nil, status: messageStatus.Ready.rawValue)
        
        self.save()
        
        DAOPostgres.sharedInstance.sendImageMessage(id, username: username, lifeTime: lifeTime, contentKey: key, sentDate: now)
        
        DAOParse.sharedInstance.sendImageOnKey(key, image: EncryptTools.encImage(image.mediumQualityJPEGNSData, targetUsername: username), filter: filter)
        
        DAOParse.pushImageNotification(username)
        
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    func sendMessage(username: String, audio: NSData, lifeTime: Int, filter: AudioFilter) -> Message
    {
        let now = NSDate()
        
        let id = self.createMessageKey(username, date: now)
        let key = self.createContentKey(id)
        
        DAOContents.sharedInstance.addAudio(key, data: audio, filter: filter)
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: lifeTime, type: .Audio, contentKey: key, text: nil, status: messageStatus.Ready.rawValue)
        
        self.save()
        
        DAOPostgres.sharedInstance.sendAudioMessage(id, username: username, lifeTime: lifeTime, contentKey: key, sentDate: now)
        
        DAOParse.sharedInstance.sendAudioOnKey(key, audio: EncryptTools.encImage(audio, targetUsername: username), filter: filter)
        
        DAOParse.pushAudioNotification(username)
        
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    /**
     * Sending message function.
     * Type: Gif
     *
     * Obs: Calls a extern function, from some Data access
     *      from or to net. In this functions above, we just
     *      add this message to the CoreData, and using the
     *      extern function we send this message to the DB
     */
    func sendMessage(username: String, gifName: String) -> Message
    {
        let now = NSDate()
        
        let id = self.createMessageKey(username, date: now)
        
        let time = UserLayoutSettings.sharedInstance.getCurrentSecondsTextLifespan()
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: time, type: .Gif, contentKey: gifName, text: nil, status: messageStatus.Ready.rawValue)
        
        self.save()
        
        DAOPostgres.sharedInstance.sendGifMessage(id, username: username, lifeTime: time, gifName: gifName, sentDate: now)
        
        let gif = DAOContents.sharedInstance.getGifWithName(gifName)
        if(gif == nil) { DAOParse.sharedInstance.downloadGif(gifName) }
        
        DAOParse.pushImageNotification(username)
        
        return message
    }
    
    func reSendImageMessage(username: String, contentKey: String, lifeTime: Int, filter: ImageFilter) -> Message?
    {
        let now = NSDate()
        
        let id = self.createMessageKey(username, date: now)
        let key = self.createContentKey(id)
        
        let image = DAOContents.sharedInstance.getImageFromKey(contentKey)
        if(image != nil)
        {
            DAOSentMidia.sharedInstance.reSendMidia(contentKey)
            let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: lifeTime, type: .Image, contentKey: key, text: nil, status: messageStatus.Ready.rawValue)
            
            self.save()
            
            DAOPostgres.sharedInstance.sendImageMessage(id, username: username, lifeTime: lifeTime, contentKey: key, sentDate: now)
            
            DAOParse.pushImageNotification(username)
            
            DAOSentMidia.sharedInstance.addSentMidia(message)
            
            return message
        }
        
        return nil
    }
    
    /**
     * Funcao que desliga o delay para mandar push
     * notifications. Ou seja, após um tempo é possivel
     * mandr push's novamente.
     */
    func turnOffDelayForPush(timer: NSTimer)
    {
        self.delay = false
    }
    
    /**
     * Funcao que adicion uma mensagem recebida.
     * Antes da adição, verifica se a mesma ja existe.
     *
     * Tipo: Texto
     */
    func addReceivedMessage(id: String, sender: String, text: String, sentDate: NSDate, lifeTime: Int) -> Bool
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return false
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Text, contentKey: nil, text: text, status: messageStatus.Received.rawValue)
        
        self.save()
        self.lastMessage = message
        
        NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.newMessage(), object: nil, userInfo: nil)
        
        return true
    }
    
    /**
     * Funcao que adicion uma mensagem recebida.
     * Antes da adição, verifica se a mesma ja existe.
     * Marca com a chave de conteudo, pois o conteudo em si
     * nao fica na propria mensagem.
     *
     * Tipo: Image, Gif, Video, Audio
     */
    func addReceivedMessage(id: String, sender: String, contentKey: String, sentDate: NSDate, lifeTime: Int, type: ContentType) -> Bool
    {
        //Tratamento de excessao
        let query = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ AND target == %@ AND sentDate == %@", sender, DAOUser.sharedInstance.getUsername(), sentDate)
        query.predicate = predicate
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(query) as! [Message]
            if(results.count > 0)
            {
                return false
            }
        }
        catch {}
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: type, contentKey: contentKey, text: nil, status: messageStatus.Received.rawValue)
        
        if(type == ContentType.Image)
        {
            DAOParse.sharedInstance.downloadImageForMessage(contentKey, id: id)
        }
        else if(type == ContentType.Gif)
        {
            let gif = DAOContents.sharedInstance.getGifWithName(message.contentKey!)
            if(gif == nil) { DAOParse.sharedInstance.downloadGif(contentKey) }
        }
        
        self.save()
        self.lastMessage = message
        
        NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.newMessage(), object: nil, userInfo: nil)
        
        return true
    }
    
    
    /**
     * Marca uma mensagem como vista.
     * Deve utilizar uma funcao extra de acesso ao
     * banco de dados na nuvem para marcar tambem
     * a mensagem como vista.
     */
    func setMessageSeen(message: Message)
    {
        if(message.status == messageStatus.Received.rawValue)
        {
            DAOPostgres.sharedInstance.setMessageSeen(message.id)
            
            message.status = messageStatus.Seen.rawValue
            self.save()
            NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.messageSeen(message.id), object: nil)
        }
    }
    
    /**
     * Funcao que deve ser utilizada apos a exclusao
     * de uma mensagem. A mesma marca no banco de dados
     * que a mensagem em questao foi deletada.
     */
    func setMessageDeleted(id: String)
    {
        DAOPostgres.sharedInstance.setDeletedMessage(id)
    }
    
    func setMessageSent(id: String)
    {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Message]
            let message = results.last
            message?.status = messageStatus.Sent.rawValue
            self.save()
            NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.messageSent(id), object: nil, userInfo: nil)
        }
        catch
        {
            return
        }
    }
    
    func setMessageError(id: String)
    {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Message]
            let message = results.last
            message?.status = messageStatus.ErrorSent.rawValue
            self.save()
            NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.messageSendError(id), object: nil, userInfo: nil)
        }
        catch
        {
            return
        }
    }
    
    func checkMessageStatus(id: String) -> String?
    {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Message]
            let message = results.last
            return message?.status
        }
        catch
        {
            return nil
        }
    }
    
    /**
     * Funcao que deleta uma mensagem.
     * Retorna true caso a exclusao tenha sido feita
     * com sucesso e false caso contrario.
     */
    func deleteMessage(id: String, atualizaNoBanco: Bool) -> Bool
    {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Message]
            if let mssg = results.first
            {
                var contact: String
                if(mssg.sender == DAOUser.sharedInstance.getUsername())
                {
                    contact = mssg.target
                }
                else
                {
                    contact = mssg.sender
                    self.setMessageDeleted(id)
                }
                let index = self.conversationWithContact(contact).indexOf(mssg)
                
                //Deleta um possivel conteudo
                let key = mssg.contentKey
                
                self.managedObjectContext.deleteObject(mssg)
                self.save()
                
                TimeBomb.sharedInstance.removeTimer(id)

                NSNotificationCenter.defaultCenter().postNotificationName(FTNChatNotifications.messageErased(), object: nil, userInfo: ["contact": contact, "index": index!])
                
                if(key != nil)
                {
                    DAOContents.sharedInstance.removeAudio(key!)
                    DAOContents.sharedInstance.removeImage(key!)
                    DAOContents.sharedInstance.removeVideo(key!)
                }

                return true
            }
        }
        catch
        {
            return false
        }
        
        return false
    }
    
    
    
    
    /** Funcao que verifica se uma mensagem possui o status
     *  seen. Caso possuir nao faz nada pois ja foi jurada
     * de morte, ops, para deletar. Caso o status seja "received",
     * seta o valor "seen" para a mensagem, modifica no banco
     * e inicia o contador para apagar a mesma apos o fim do tempo.
     */
    func deleteMessageAfterTime(message: Message)
    {
        if(message.status == messageStatus.Received.rawValue && message.sender != DAOUser.sharedInstance.getUsername())
        {
            self.setMessageSeen(message)
            let now = NSDate()
            
            TimeBomb.sharedInstance.addTimer(message.id, seenDate: now, lifeTime: Int(message.lifeTime))
            let timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(message.lifeTime), target: self, selector: "receiveTimesUpNotification:", userInfo: ["id":message.id], repeats: false)
        }
    }
    
    
    func receiveTimesUpNotification(timer: NSTimer)
    {
        print("tempo de execucao finalizado para exclusao")
        let id = timer.userInfo?.objectForKey("id") as! String
        self.deleteMessage(id, atualizaNoBanco: true)
    }
    
   
    
    
    /*************************************************
     *                                               *
     *   CONVERSATIONS AND GROUPS FROM CONTACTS      *
     *                                               *
     *************************************************/
    
    
    func getMessageFromConversation(sender: String, target: String, sentDate: NSDate) -> Message?
    {
        let conversation = self.conversationWithContact(target)
        
        let dateCompare = Optimization.getBigStringFromDate(sentDate)
        
        for message in conversation
        {
            let messageDate = Optimization.getBigStringFromDate(message.sentDate)
                        
            if(messageDate == dateCompare)
            {
                return message
            }
            else
            {
            }
        }
        
        return nil
    }

    
    func contactMessageExist(message: Message) -> Bool
    {
        let pred1 = NSPredicate(format: "sender == %@", message.sender)
        let pred2 = NSPredicate(format: "target == %@", message.target)
        let pred3 = NSPredicate(format: "sentDate == %@", message.sentDate)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1, pred2, pred3])
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            if(results.count > 0)
            {
                return true
            }
            else
            {
                return false
            }
        }
        catch
        {
            return false
        }
    }
    
    func messageForId(id: String) -> Message?
    {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Message]
            return results.first
        }
        catch
        {
            return nil
        }
    }

    
    func conversationWithContact(contact: String?) -> [Message]
    {
        let pred1 = NSPredicate(format: "sender == %@ OR target == %@", contact!, contact!)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1])
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sentDate", ascending: true)]
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            return results
        }
        catch
        {
            return [Message]()
        }
    }
    
    func numberOfTodayMessages(messages: [Message]) -> Int
    {
        var i = 0
        
        for message in messages
        {
            let now = NSDate()
            
            if(NSCalendar.currentCalendar().compareDate(now, toDate: message.sentDate,
            toUnitGranularity: .Day) == .OrderedSame)
            {
                i++
            }
        }
        
        return i
    }

    func clearConversation(username: String)
    {
        let messages = self.conversationWithContact(username)
        
        for message in messages
        {
            self.deleteMessage(message.id, atualizaNoBanco: true)
        }
    }
    
    func numberOfUnreadMessages(contact: Contact) -> Int
    {
        var unread = 0
        
        let messages = self.conversationWithContact(contact.username)
        
        for message in messages
        {
            if message.status == messageStatus.Received.rawValue
            {
                unread++
            }
        }
        
        return unread
    }
    
    func allUnreadMessages() -> Int
    {
        let predicate = NSPredicate(format: "status == %@", messageStatus.Received.rawValue)
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            return results.count
        }
        catch
        {
            return 0
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




