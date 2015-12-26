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
        let now = NSDate()
        let id = self.createMessageKey(username, date: now)
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: self.defaultTime, type: .Text, contentKey: nil, text: text, status: "sent")
        
        self.save()
        
        DAOPostgres.sharedInstance.sendTextMessage(id, username: username, lifeTime: self.defaultTime, text: text, sentDate: now)
        
        if(!self.delay)
        {
            self.delay = true
            DAOParse.pushMessageNotification(username, text: text)
            self.delayForPush?.invalidate()
            self.delayForPush = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "turnOffDelayForPush:", userInfo: nil, repeats: false)
        }
        
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: lifeTime, type: .Image, contentKey: key, text: nil, status: "sent")
        
        self.save()
        
//        DAOPostgres.sharedInstance.sendImageMessage(EncryptTools.encUsername(username), lifeTime: lifeTime, imageKey: key, image: image, filter: filter, sentDate: now)
        
//        DAOParse.sharedInstance.sendImageOnKey(key, image: EncryptTools.encImage(image.mediumQualityJPEGNSData, target: username))
        
        DAOParse.pushImageNotification(username)
        
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: DAOUser.sharedInstance.getUsername(), target: username, sentDate: now, lifeTime: self.defaultTime, type: .Gif, contentKey: gifName, text: nil, status: "sent")
        
        self.save()
        
        DAOPostgres.sharedInstance.sendGifMessage(id, username: username, lifeTime: self.defaultTime, gifName: gifName, sentDate: now)
        
        DAOParse.pushImageNotification(username)
        
        return message
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: .Text, contentKey: nil, text: text, status: "received")
        
        self.save()
        self.lastMessage = message
        
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
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
        
        let message = Message.createInManagedObjectContext(self.managedObjectContext, id: id, sender: sender, target: DAOUser.sharedInstance.getUsername(), sentDate: sentDate, lifeTime: lifeTime, type: type, contentKey: contentKey, text: nil, status: "received")
        
        self.lastMessage = message
        NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.messageReceived)
        
        self.save()
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
        if(message.status != "seen")
        {
            DAOPostgres.sharedInstance.setMessageSeen(message.id)
            
            message.status = "seen"
            self.save()
        }
    }
    
    /**
     * Funcao que deve ser utilizada apos a exclusao
     * de uma mensagem. A mesma marca no banco de dados
     * que a mensagem em questao foi deletada.
     */
    func setMessageDeleted(message: Message)
    {
        DAOPostgres.sharedInstance.setDeletedMessage(message.id)
    }
    
    
    /**
     * Funcao que deleta uma mensagem.
     * Retorna true caso a exclusao tenha sido feita
     * com sucesso e false caso contrario.
     */
    func deleteMessage(id: String) -> Bool
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
                }
                let index = self.conversationWithContact(contact).indexOf(mssg)
                
                self.managedObjectContext.deleteObject(mssg)
                self.save()

                TimeBomb.sharedInstance.removeTimer(id)

                NSNotificationCenter.defaultCenter().postNotificationName(NotificationController.center.messageEvaporated.name, object: nil, userInfo: ["contact": contact, "index": index!])

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
        if(message.status != "seen")
        {
            self.setMessageSeen(message)
            let now = NSDate()
            
            TimeBomb.sharedInstance.addTimer(message.id, seenDate: now, lifeTime: Int(message.lifeTime))
            
            let timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(message.lifeTime), target: self, selector: "receiveTimesUpNotification:", userInfo: ["message":message], repeats: false)
            self.timeBomb.setObject(timer, forKey: message.sentDate)
        }
    }
    
    
    func receiveTimesUpNotification(timer: NSTimer)
    {
        print("tempo de execucao finalizado para exclusao")
        let message = timer.userInfo?.objectForKey("message") as! Message
        self.deleteMessage(message.id)
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
//    func timesUpMessage(message: Message?)
//    {
//        print("excluindo mensagem...")
//        if(!self.inExecution)
//        {
//            self.inExecution = true
//            
//            //Apaga um possivel timer para essa mensagem
//            if(message == nil) { return }
//            let timer = self.timeBomb.objectForKey(message!.sentDate) as? NSTimer
//            timer?.invalidate()
//            self.timeBomb.removeObjectForKey(message!.sentDate)
//            //Fim da remocao de um possivel timer
//            
//            var contact : String?
//            if (message?.sender == DAOUser.sharedInstance.getUsername())
//            {
//                contact = message?.target
//            }
//            else
//            {
//                contact = message?.sender
//            }
//            
//            let messages = self.conversationWithContact(contact)
//            if(message == nil) { return }
//            let index = messages.indexOf(message!)
//            
//            if(message == nil) { return }
//            DAOPostgres.sharedInstance.setDeletedMessage(message!)
//
//            if(self.deleteMessage(message!))
//            {
//                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "messageEvaporated", object: nil, userInfo: ["index":index!, "contact": contact!]))
//            }
//            self.inExecution = false
//        }
//        else
//        {
//            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(0.2)) * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//                self.timesUpMessage(message)
//            }
//        }
//    }
    
    
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

    func clearConversation(username: String)
    {
        let messages = self.conversationWithContact(username)
        
        for message in messages
        {
            self.deleteMessage(message.id)
        }
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
    
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
    
}




