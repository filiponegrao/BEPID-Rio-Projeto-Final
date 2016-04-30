//
//  AppDelegate.swift
//  ProjetoFinal
//
//  Created by Filipo Negrao on 09/09/15.
//  Copyright (c) 2015 FFV. All rights reserved.
//

import UIKit
import CoreData
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var tentativasUpload : Int = 0
    
    var tentativasAudio : Int = 0
    
    let hibernateImage = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        Parse.setApplicationId("nxY5lzIPinULd8EmSTxb09vxmVx08tyC1Y2Rt2HK",
            clientKey: "ULiq579xkqwfJF3OKjMJeSLYX42UQ54jvEydaB8s")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        //Background fetch
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        DAOMessages.sharedInstance.checkForOldMessages()
        BlackList.initBlackList()
        TheJudger.Singleton.inicializandoJudger()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let usercondition = DAOUser.sharedInstance.isLoged()
        
        if(usercondition == UserCondition.userLogged)
        {
            if(PFUser.currentUser() != nil)
            {
                let contacts = AppNavigationController()
                self.window?.rootViewController = contacts
            }
            else
            {
                let contacts = LoadingInfo_ViewController(nibName: "LoadingInfo_ViewController", bundle: nil)
                self.window?.rootViewController = contacts

            }
        }
        else if(usercondition == UserCondition.userLoggedOut)
        {
            let tutorial = Tutorial_ViewController()
            self.window?.rootViewController = tutorial
        }
        else if(usercondition == UserCondition.incompleteRegister)
        {
            let validate = FacebookRegister_ViewController(nibName: "FacebookRegister_ViewController", bundle: nil)
            self.window?.rootViewController = validate
        }
        else if(usercondition == UserCondition.termsUnaccepted)
        {
            let terms = Privacy_ViewController(nibName: "Privacy_ViewController", bundle: nil)
            self.window?.rootViewController = terms
        }
        else if(usercondition == UserCondition.contactsNotImported)
        {
            let contacts = Import_ViewController(nibName: "Import_ViewController", bundle: nil)
            self.window?.rootViewController = contacts
        }
        else if(usercondition == UserCondition.notLinkedFacebook)
        {
            let contacts = AppLoginImport_ViewController()
            self.window?.rootViewController = contacts
        }
        
        self.window?.makeKeyAndVisible()
        
        //Status bar color
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.hibernateImage.image = UIImage(named: "appBackground")
        
        // Register for Push Notitications *******************************
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:®didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
    
        
        if application.respondsToSelector("registerUserNotificationSettings:")
        {
            let userNotificationTypes = (UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue)
            
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.init(rawValue: userNotificationTypes), categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else
        {
            let type = UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue
            
            application.registerUserNotificationSettings(UIUserNotificationSettings.init(forTypes: UIUserNotificationType.init(rawValue: type), categories: nil))
        }
        // Fim das configuracoes de notificacao ********************************
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)        
    }
    
    //Facebook
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
            return FBSDKApplicationDelegate.sharedInstance().application( application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  
        UIView.animateWithDuration(0.6, animations: { 
            
            self.window?.addSubview(self.hibernateImage)
            
            }) { (true) in
                
                UIView.animateWithDuration(0.6, delay: 0.3, options: .CurveEaseIn, animations: {
                    self.hibernateImage.alpha = 1.0
                }) { (true) in
                    
                }
        }
     

    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        if(DAOUser.sharedInstance.isLoged() == UserCondition.userLogged)
        {
            DAOContacts.sharedInstance.refreshContacts()
            DAOPostgres.sharedInstance.getUnreadAndDeletedMessages()
        }
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.hibernateImage.alpha = 0
            
        }) { (true) in
            
            UIView.animateWithDuration(0.6, delay: 0.3, options: .CurveEaseOut, animations: {
               
                if(self.hibernateImage.image != nil)
                {
                    self.hibernateImage.removeFromSuperview()
                }
                
            }) { (true) in
                
            }
        }
        
    }
    
    func applicationWillTerminate(application: UIApplication)
    {
        DAOPostgres.sharedInstance.stopObserve()
        DAOPostgres.sharedInstance.stopRefreshing()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    //PARSE NOTIFICATION ***********
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let installation = PFInstallation.currentInstallation()
        
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        DAOPostgres.sharedInstance.getUnreadMessages()
        print("didReceiveRemoteNotification \(userInfo)")
        let notification = userInfo as NSDictionary
        
        application.applicationIconBadgeNumber = DAOMessages.sharedInstance.allUnreadMessages()
        
        if (application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive)
        {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            
            if(DAOUser.sharedInstance.isLoged() == UserCondition.userLogged)
            {
                let user = notification.valueForKey("sender") as? String
                if(user != nil)
                {
                    let controller = self.window?.rootViewController as! AppNavigationController
                    
                    if(controller.home.chatController != nil)
                    {
                        let contact = DAOContacts.sharedInstance.getContact(user!)
                        if(contact != nil)
                        {
                            controller.popToRootViewControllerAnimated(false)
                            controller.home.chatController.reloadConversation(contact!.username)
                            controller.pushViewController(controller.home.chatController, animated: false)
                            self.window?.rootViewController = controller
                        }
                    }
                    else
                    {
                        let contact = DAOContacts.sharedInstance.getContact(user!)
                        if(contact != nil)
                        {
                            controller.home.chatController = Chat_ViewController(contact: contact!, homeController: controller.home)
                            controller.popToRootViewControllerAnimated(false)
                            controller.pushViewController(controller.home.chatController, animated: false)
                            self.window?.rootViewController = controller
                        }
                    }

                }
            }
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "FilipoNegrao.TesteBD" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //Background fetch
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        
    }
    
    
    //Aux functions
    func sendImageOnKey(key: String, image: NSData, filter: ImageFilter)
    {
        let file = PFFile(data: image)
        
        let object = PFObject(className: "Images")
        object["imageKey"] = key
        object["image"] = file
        object["filter"] = filter.rawValue
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if(!success && self.tentativasUpload < 100)
            {
                self.tentativasUpload++
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1) + self.tentativasUpload) * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.sendImageOnKey(key, image: image, filter: filter)
                }
                
            }
            else
            {
                self.tentativasUpload = 0
                print("Imagem salva com sucesso!")
            }
        }
    }
    
    func sendAudioOnKey(key: String, audio: NSData, filter: AudioFilter)
    {
        let file = PFFile(data: audio)
        
        let object = PFObject(className: "Audios")
        object["audioKey"] = key
        object["audio"] = file
        object["filter"] = filter.rawValue
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if(!success && self.tentativasAudio < 100)
            {
                self.tentativasAudio++
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(Int(1) + self.tentativasAudio) * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.sendAudioOnKey(key, audio: audio, filter: filter)
                }
                
            }
            else
            {
                self.tentativasAudio = 0
                print("Audio salvo com sucesso!")
            }
        }
    }
}

