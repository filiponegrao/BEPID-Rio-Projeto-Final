//
//  AppDelegate.swift
//  ProjetoFinal
//
//  Created by Filipo Negrao on 09/09/15.
//  Copyright (c) 2015 FFV. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        Parse.setApplicationId("nxY5lzIPinULd8EmSTxb09vxmVx08tyC1Y2Rt2HK",
            clientKey: "ULiq579xkqwfJF3OKjMJeSLYX42UQ54jvEydaB8s")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        TheJudger.Singleton.inicializandoJudger()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if(DAOUser.sharedInstance.isLoged() == UserCondition.userLogged)
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
        else if(DAOUser.sharedInstance.isLoged() == UserCondition.userLoggedOut)
        {
            let login = Login_ViewController(nibName: "Login_ViewController", bundle: nil)
            self.window?.rootViewController = login
        }
        else if(DAOUser.sharedInstance.isLoged() == UserCondition.incompleteRegister)
        {
            let validate = FacebookRegister_ViewController(nibName: "FacebookRegister_ViewController", bundle: nil)
            self.window?.rootViewController = validate
        }
        
//        self.window?.rootViewController = Import_ViewController(nibName: "Import_ViewController", bundle: nil)
        self.window?.makeKeyAndVisible()
        
        //Status bar color
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
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
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //PARSE NOTIFICATION ***********
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification \(userInfo)")
        let notification = userInfo as NSDictionary
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive
        {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        if(notification.valueForKey("do") as! String == appNotification.friendRequest.rawValue)
        {
            print("carregando friend requests ordenado por notifiacao")
            DAOFriendRequests.sharedInstance.loadRequests()
        }
        else if(notification.valueForKey("do") as! String == appNotification.requestAccepted.rawValue)
        {
            print("Adicionando amigo ordenado por notifiacao")
            DAOFriendRequests.sharedInstance.friendsAccepted()
        }
        else if(notification.valueForKey("do") as! String == appNotification.messageReceived.rawValue)
        {
            let sender = notification.valueForKey("sender") as! String
            DAOMessages.sharedInstance.receiveMessagesFromContact(sender)
        }
    }
    
    
}

