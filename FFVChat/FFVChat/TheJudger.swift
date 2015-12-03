//
//  TheJudger.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import Photos

import Parse

private let data : TheJudger = TheJudger()

class TheJudger : NSObject
{
    
    override init()
    {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "judge", name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        
    }
    
    func inicializandoJudger()
    {
        print("Judger Pronto!")
    }
    
    class var Singleton : TheJudger
    {
        return data
    }
    

    func judge()
    {
        if(PFUser.currentUser() != nil)
        {
            DAOUser.sharedInstance.decreaseTrustLevel()
//            let controller = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController
            let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "deletePhoto", userInfo: nil, repeats: false)
        }
    }
    
    
    func deletePhoto()
    {
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        if (fetchResult.lastObject != nil) {
            
            let lastAsset: PHAsset = fetchResult.lastObject as! PHAsset
            
            let arrayToDelete = NSArray(object: lastAsset)
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
                PHAssetChangeRequest.deleteAssets(arrayToDelete)},
                completionHandler: {
                    success, error in
                    NSLog("Finished deleting asset. %@", (success ? "Success" : error!))
            }) 
            
            
            
        }
    }
}


