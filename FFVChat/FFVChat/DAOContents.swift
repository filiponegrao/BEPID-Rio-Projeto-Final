//
//  DAOContents.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let data = DAOContents()

/**
 * Classe responsavel por administrar os conteudos armazenados.
 */
class DAOContents : NSObject
{
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override init()
    {
//        DAOPostgres.sharedInstance.addAllGifs()
    }
    
    class var sharedInstance : DAOContents
    {
        return data
    }
    
    /*************************************************
     *                                               *
     *                IMAGE SECTION                  *
     *                                               *
     *************************************************/

    func addImage(imageKey: String, data: NSData, filter: ImageFilter, preview: NSData) -> Bool
    {
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Image]
            if(results.count == 0)
            {
                Image.createInManagedObjectContext(self.managedObjectContext, data: data, filter: filter, imageKey: imageKey, preview: preview)
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "imageLoaded", object: nil, userInfo: ["imageKey":imageKey]))
                self.save()
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
    
    func removeImage(imageKey: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            if(results.count != 0)
            {
                self.managedObjectContext.deleteObject(results.first!)
                self.save()
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
    
    func getImageFromKey(imageKey: String) -> UIImage?
    {
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Image]
            if(results.count != 0)
            {
                let image = results.first!
                
                return UIImage(data: image.data)!
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }

    func getImageInfoFromKey(imageKey: String) -> Image?
    {
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "imageKey == %@", imageKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Image]
            if(results.count != 0)
            {
                let image = results.first!
                
                return image
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    
    /*************************************************
     *                                               *
     *                 GIF SECTION                   *
     *                                               *
     *************************************************/
    
     
     /**
      * ATENCAO: FUNCAO ACOPLADA COM PARSE
      */
    func downloadGif(name: String)
    {
        let gif = self.getGifWithName(name)
        
        if(gif == nil)
        {
            DAOParse.sharedInstance.downloadGif(name)
        }
        else
        {
            
        }
    }
     
     
    /** Adiciona os gifs */
    func addGif(name: String, data: NSData, hashtags: [String], launchedDate: NSDate) -> Bool
    {
        let dataH = Optimization.stringArrayToData(hashtags)
        
        let request = NSFetchRequest(entityName: "Gif")
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            if(result.count == 0)
            {
                Gif.createInManagedObjectContext(self.managedObjectContext, data: data, hashtags: dataH, name: name, launchedDate: launchedDate)
                self.save()
                return true
            }
            else
            {
                let existent = result.first
                existent?.data = data
                existent?.hashtags = dataH
                existent?.launchedDate = launchedDate
                self.save()
                
                return true
            }
        }
        catch
        {
            return false
        }
    }
    
    func removeGif(name: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "Gif")
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            if(result.count != 0)
            {
                self.managedObjectContext.deleteObject(result.first!)
                self.save()
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
    
    func getGifWithName(name: String) -> Gif?
    {
        let request = NSFetchRequest(entityName: "Gif")
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            if(result.count != 0)
            {
                let gif = result.first!
                
                return gif
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    func getNewestGifs() -> [Gif]
    {
        var newGifs = [Gif]()
        let calendar = NSCalendar.currentCalendar()
        let pastMonth = calendar.dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: [])

        let request = NSFetchRequest(entityName: "Gif")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            for result in results
            {
                if(result.launchedDate.isGreaterThanDate(pastMonth!))
                {
                    newGifs.append(result)
                }
            }
            
            return newGifs
            
        }
        catch
        {
            return newGifs
        }
    }
    
    func getOldestGifs() -> [Gif]
    {
        var newGifs = [Gif]()
        let calendar = NSCalendar.currentCalendar()
        let pastMonth = calendar.dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: [])
        
        
        let request = NSFetchRequest(entityName: "Gif")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            for result in results
            {
                if(pastMonth!.isGreaterThanDate(result.launchedDate))
                {
                    newGifs.append(result)
                }
            }
            
            return newGifs
            
        }
        catch
        {
            return newGifs
        }
    }
    
    
    func getAllGifs() -> [Gif]
    {
        var newGifs = [Gif]()
        
        let request = NSFetchRequest(entityName: "Gif")
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Gif]
            for result in results
            {
                newGifs.append(result)
            }
            
            return newGifs
            
        }
        catch
        {
            return newGifs
        }
    }
    
    func getUrlFromGifName(name: String) -> String
    {
        return "http://www.mynechat.com/gifs/\(name).gif"
    }
    
    /*************************************************
     *                                               *
     *               AUDIO SECTION                   *
     *                                               *
     *************************************************/
     
    func addAudio(audioKey: String, data: NSData, filter: AudioFilter) -> Bool
    {
        let request = NSFetchRequest(entityName: "Audio")
        request.predicate = NSPredicate(format: "audioKey == %@", audioKey)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Audio]
            if(result.count == 0)
            {
                Audio.createInManagedObjectContext(self.managedObjectContext, data: data, audioKey: audioKey, filter: filter)
                self.save()
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "audioLoaded", object: nil, userInfo: ["audioKey":audioKey]))

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
    
    func removeAudio(audioKey: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "Audio")
        request.predicate = NSPredicate(format: "audioKey == %@", audioKey)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Audio]
            if(result.count != 0)
            {
                self.managedObjectContext.deleteObject(result.first!)
                self.save()
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
    
    func getAudioFromKey(audioKey: String) -> NSData?
    {
        let request = NSFetchRequest(entityName: "Audio")
        request.predicate = NSPredicate(format: "audioKey == %@", audioKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Audio]
            if(results.count != 0)
            {
                let audio = results.first!
                
                return audio.data
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    func existAudioFromKey(audioKey: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "Audio")
        request.predicate = NSPredicate(format: "audioKey == %@", audioKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Audio]
            if(results.count != 0)
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
    
    
    /*************************************************
     *                                               *
     *               VIDEO SECTION                   *
     *                                               *
     *************************************************/
    
    func addvideo(videoKey: String, data: NSData, filter: VideoFilter, preview: NSData) -> Bool
    {
        let request = NSFetchRequest(entityName: "Video")
        request.predicate = NSPredicate(format: "videoKey == %@", videoKey)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Audio]
            if(result.count == 0)
            {
                Video.createInManagedObjectContext(self.managedObjectContext, data: data, videoKey: videoKey, filter: filter, preview: preview)
                self.save()
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
    
    func removeVideo(videoKey: String) -> Bool
    {
        let request = NSFetchRequest(entityName: "Video")
        request.predicate = NSPredicate(format: "videoKey == %@", videoKey)
        
        do
        {
            let result = try self.managedObjectContext.executeFetchRequest(request) as! [Video]
            if(result.count != 0)
            {
                self.managedObjectContext.deleteObject(result.first!)
                self.save()
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
    
    func getVideoFromKey(videoKey: String) -> NSData?
    {
        let request = NSFetchRequest(entityName: "Video")
        request.predicate = NSPredicate(format: "videoKey == %@", videoKey)
        
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(request) as! [Video]
            if(results.count != 0)
            {
                let video = results.first!
                
                return video.data
            }
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }

    
    /**
     * Funcao que salva as informacoes modificadas.
     */
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
    
    
}






