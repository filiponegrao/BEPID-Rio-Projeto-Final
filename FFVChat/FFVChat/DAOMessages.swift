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
    let defaultTime = 900
    
    var currentMessage : Message?
    
    var lastMessage : Message!
    
    var inExecution: Bool = false
    
    var delayForPush : NSTimer!
    
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
    var timeBomb = NSMutableDictionary()
    
    override init()
    {
        super.init()
        self.currentMessage = nil
    }
    
    class var sharedInstance : DAOMessages
    {
        return data
    }
    
    
    func sendMessage(username: String, text: String) -> Message
    {
        let now = NSDate()
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: self.defaultTime, type: .Text, contentKey: nil, text: text, image: nil, filter: nil, audio: nil, gif: nil, status: "sent")
        
        self.save()
        
        DAOPostgres.sharedInstance.sendTextMessage(EncryptTools.encUsername(username), lifeTime: self.defaultTime, text: EncryptTools.enc(text, contact: username), sentDate: now)
        
        self.delayForPush?.invalidate()
        self.delayForPush = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "sendTextPushNotification:", userInfo: ["username":username, "text":text], repeats: false)
        
        return message
    }
    
    func sendMessage(username: String, image: UIImage, lifeTime: Int, filter: ImageFilter) -> Message
    {
        let data = NSString(string: "\(NSDate())").substringWithRange(NSMakeRange(0, 19))
        let keyWithSpaces = "\(DAOUser.sharedInstance.getUsername())\(username)\(data)"
        var key = EncryptTools.removeWhiteSpaces(keyWithSpaces)
        key = EncryptTools.encKey(key)
        
        let now = NSDate()
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: lifeTime, type: .Image, contentKey: key, text: nil, image: image.mediumQualityJPEGNSData, filter: filter, audio: nil, gif: nil, status: "sent")
        
        
        self.save()
        
        DAOPostgres.sharedInstance.sendImageMessage(EncryptTools.encUsername(username), lifeTime: lifeTime, imageKey: key, image: image, filter: filter, sentDate: now)
        
        DAOParse.sharedInstance.sendImageOnKey(key, image: EncryptTools.encImage(image.mediumQualityJPEGNSData, target: username))
        
        DAOParse.pushImageNotification(username)
        
        DAOSentMidia.sharedInstance.addSentMidia(message)
        
        return message
    }
    
    func sendMessage(username: String, gifName: String, gifData: NSData) -> Message
    {
//        let data = NSString(string: "\(NSDate())").substringWithRange(NSMakeRange(0, 19))
//        let keyWithSpaces = "\(DAOUser.sharedInstance.getUsername())\(username)\(data)"
//        var key = EncryptTools.removeWhiteSpaces(keyWithSpaces)
//        key = EncryptTools.encKey(key)
        let now = NSDate()
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: self.defaultTime, type: .Gif, contentKey: gifName, text: nil, image: nil, filter: nil, audio: nil, gif: gifData, status: "sent")
        
        self.save()
        
        DAOPostgres.sharedInstance.sendGifMessage(EncryptTools.encUsername(username), lifeTime: self.defaultTime, gifKey: gifName, sentDate: now)
        
        DAOParse.pushImageNotification(username)
        
        return message
    }
    
    
    func sendTextPushNotification(timer: NSTimer)
    {
        let info  = timer.userInfo!
        let username = info["username"] as! String
        let text = info["text"] as! String
        
        DAOParse.pushMessageNotification(username, text: text)
    }
    
    
    func addReceivedMessage(sender: String, text: String, sentDate: NSDate, lifeTime: Int) -> Bool
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Text, contentKey: nil, text: text, image: nil, filter: nil, audio: nil, gif: nil, status: "received")
        
        self.lastMessage = message
        
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
        return true
    }
    
    func addReceivedMessage(sender: String, contentKey: String, sentDate: NSDate, lifeTime: Int, filter: ImageFilter) -> Bool
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Image, contentKey: contentKey, text: nil, image: nil, filter: filter, audio: nil, gif: nil, status: "received")
        
        DAOParse.sharedInstance.downloadImageForMessage(message)
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
        return true
    }
    
    func addReceivedMessage(sender: String, gifKey: String, gifData: NSData, sentDate: NSDate, lifeTime: Int) -> Bool
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Gif, contentKey: gifKey, text: nil, image: nil, filter: nil, audio: nil, gif: gifData, status: "received")
        
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
        return true
    }
    
    
    func setMessageSeen(message: Message)
    {
        if(message.status != "seen")
        {
            DAOPostgres.sharedInstance.setMessageSeen(message)
            
            message.status = "seen"
            self.save()
        }
    }
    
    
    func setMessageDeleted(message: Message)
    {
        DAOPostgres.sharedInstance.setDeletedMessage(message)
    }
    
    
    func deleteMessage(message: Message) -> Bool
    {
        
        let predicate = NSPredicate(format: "sentDate == %@ AND target == %@ AND sender == %@", message.sentDate, message.target, message.sender)
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            if let entityToDelete = fetchedEntities.first
            {
                self.managedObjectContext.deleteObject(entityToDelete)
                self.save()
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
        print(message.status)
        if(message.status != "seen")
        {
            self.setMessageSeen(message)
            
            let timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(message.lifeTime), target: self, selector: "receiveTimesUpNotification:", userInfo: ["message":message], repeats: false)
            self.timeBomb.setObject(timer, forKey: message.sentDate)
        }
    }
    
    
    func receiveTimesUpNotification(timer: NSTimer)
    {
        print("tempo de execucao finalizado para exclusao")
        let message = timer.userInfo?.objectForKey("message") as! Message
        self.timesUpMessage(message)
    }
    
    /**
     * Funcao que verifica se ha alguma exclusao em andamento,
     * caso nao haja, inicia uma exclusao. Caso contrario,
     * inicia um delay para que a acao seja tentada novamente.
     * OBS: Essa funcao por alguns motivos como os timers de exlcusao
     * de mensagens, possui um layout um tanto alternativo.
     * Pela razão dos timers serem assincronos, uma funcao de timer
     * pode executar essa mesma funcao junto com a thread principal
     * passando a mesma mensagem como parametro. Nesse caso algimas
     * verificacoes sao necessarias.
     */
    func timesUpMessage(message: Message?)
    {
        print("excluindo mensagem...")
        if(!self.inExecution)
        {
            self.inExecution = true
            
            //Apaga um possivel timer para essa mensagem
            if(message == nil) { return }
            let timer = self.timeBomb.objectForKey(message!.sentDate) as? NSTimer
            timer?.invalidate()
            self.timeBomb.removeObjectForKey(message!.sentDate)
            //Fim da remocao de um possivel timer
            
            var contact : String?
            if (message?.sender == DAOUser.sharedInstance.getUsername())
            {
                contact = message?.target
            }
            else
            {
                contact = message?.sender
            }
            
            let messages = self.conversationWithContact(contact)
            if(message == nil) { return }
            let index = messages.indexOf(message!)
            
            if(message == nil) { return }
            DAOPostgres.sharedInstance.setDeletedMessage(message!)

            if(self.deleteMessage(message!))
            {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "messageEvaporated", object: nil, userInfo: ["index":index!, "contact": contact!]))
            }
            self.inExecution = false
        }
        else
        {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(0.2)) * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.timesUpMessage(message)
            }
        }
    }
    
    
    func getMessageFromConversation(sender: String, target: String, sentDate: NSDate) -> Message?
    {
        let conversation = self.conversationWithContact(target)
        
        let dateCompare = Optimization.getBigStringFromDate(sentDate)
        print(conversation.count)
        
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
    
    
    /**
     * Funcao que apaga uma mensagem ja apagada no dispositivo
     * do receptor. Funcionamento: a mensagem é enviada; No recebeminto
     * o receptor marca o status dela para "received" no banco; Apos ler
     * "seen", e por ultimo apos deletar, o receptor marca a mensagem como
     * "deleted" no banco. Essa funcao e responsavel por parear tal mensagem,
     * onde se a mesma ja foi deletada no celular do receptor deve sumir
     * da conversa presente nesse celular
     */
    func deleteDeletedMessage()
    {
        
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
    
    
    
    
    func clearConversation(username: String)
    {
        let messages = self.conversationWithContact(username)
        
        for message in messages
        {
            self.deleteMessage(message)
        }
    }
    
    
    func conversationWithContact(contact: String?) -> [Message]
    {
        var messages = [Message]()
        
        if(contact == nil) { return messages }
        
        let pred1 = NSPredicate(format: "sender == %@ OR target == %@", contact!, contact!)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred1])
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sentDate", ascending: true)]
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Message]
            messages = results
        }
        catch
        {
            return messages
        }
        return messages
    }

    
    func numberOfUnreadMessages(contact: Contact) -> Int
    {
        var unread = 0
        
        let messages = self.conversationWithContact(contact.username)
        
        for message in messages
        {
            if message.status == "received"
            {
                unread++
            }
        }
        
        return unread
    }
    
    
    func setImageForMessage(message: Message, image: NSData)
    {
        message.image = image
        self.save()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "imageLoaded", object: nil, userInfo: ["messageKey" : message.contentKey!]))
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

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }


