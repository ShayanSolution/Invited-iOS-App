//
//  AppDelegate.swift
//  Invited
//
//  Created by ShayanSolutions on 4/10/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import Contacts
import FacebookCore
import TwitterKit
import PGSideMenu


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        
        return true
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        GMSPlacesClient.provideAPIKey("")
        GMSServices.provideAPIKey("")

        
//        AIzaSyBzPGNnwW86_v95lVaHHmcqDwZgIQ2QKF8


//        AIzaSyBzPGNnwW86_v95lVaHHmcqDwZgIQ2QKF8
        
        let baseURL = BasicFunctions.getPreferences(kBaseURLInPrefrences) as? String
        
        
        if kBaseURL.isEmpty && baseURL == nil
        {
            ServerManager.getURL(nil, withBaseURL: kConfigURL) { (result) in
                let urlDictionary = result as? [String : Any]

                kBaseURL = urlDictionary?["URL"] as? String ?? "http://dev.invited.shayansolutions.com/"
                kBaseURL = String(format: "http://%@/", kBaseURL)
                kBirthdayMessage = urlDictionary?["BirthdayAlert"] as? String ?? kBirthdayMessage
                
                BasicFunctions.setPreferences(kBaseURL, key: kBaseURLInPrefrences)
                
                
                
            }
        }
        else if kBaseURL.isEmpty && baseURL != nil
        {
            kBaseURL = baseURL!
        }
        
        
        if BasicFunctions.getIfUserLoggedIn()
        {
            BasicFunctions.setHomeVC()
        }
        
        
        
        self.registerForPushNotifications(application: application)
        
        
//        if launchOptions != nil
//        {
//            
//            if #available(iOS 10.0, *) {
//                
//                let notification  = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? UNNotification
//                
//                if notification != nil
//                {
//                    NotificationCenter.default.post(name: Notification.Name("ReceiveNotificationData"), object: nil, userInfo: notification?.request.content.userInfo["custom_data"] as? [AnyHashable : Any] )
//                }
//                
//            } else {
//                // Fallback on earlier versions
//            }
//            
//            
//        }
        
        
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings.init(types: [.badge,.sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        BasicFunctions.setPreferences(token, key: kDeviceToken)
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
//    {
//        
//        print("Notification data: \(userInfo)")
//
//
//
//    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        
        completionHandler([.badge,.alert, .sound])
        
        print("Notification data: \(notification.request.content.userInfo)")
//        NotificationCenter.default.post(name: Notification.Name("ReceiveNotificationData"), object: nil, userInfo: notification.request.content.userInfo["custom_data"] as! [AnyHashable : Any] )
        
       UIApplication.shared.applicationIconBadgeNumber = 0
        
        

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        
        
        
        print("Notification data: \(response.notification.request.content.userInfo)")
        
        
        if ((self.window?.rootViewController as? PGSideMenu)?.contentController as? UINavigationController)?.topViewController is HomeVC
        {
//            kIsNotificationReceived = true
            NotificationCenter.default.post(name: Notification.Name("ReceiveNotificationData"), object: nil, userInfo: response.notification.request.content.userInfo["custom_data"] as? [String : Any] )
        }
        else
        {
            kNotificationData = response.notification.request.content.userInfo["custom_data"] as? [String : Any]
            BasicFunctions.pushVCinNCwithName("HomeVC", popTop: true)
        }
        
        
        
        
        
        
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//        return Twitter.sharedInstance().application(app, open: url, options: options)
        
//        if TWTRTwitter.sharedInstance().application(app, open:url, options: options) {
//            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//        }
//
//
//        let appId = SDKSettings.appId
//        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
//            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        

        
        
        application.applicationIconBadgeNumber = 0
        if BasicFunctions.getIfUserLoggedIn()
        {
            
            CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                if (granted){
                    
                    BasicFunctions.fetchAllContactsFromDevice()
                    BasicFunctions.query()
                }
            })
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

