//
//  AppDelegate.swift
//  BackgroundTest
//
//  Created by Dean Woodward on 17/04/16.
//  Copyright © 2016 Dean Woodward. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if(UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil))
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        Logger.sharedInstance.demarcate()
        Logger.sharedInstance.log("in handleEventsForBackgroundURLSession")
        Logger.sharedInstance.log("Identifier: \(identifier)")
        Logger.sharedInstance.demarcate(withDate: false)
        
//        let notification = UILocalNotification()
//        notification.alertTitle = "Success"
//        notification.alertBody = "Load submitted successfully"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.applicationIconBadgeNumber = 1
//        UIApplication.sharedApplication().presentLocalNotificationNow(notification)

        NetworkManager.backgroundManager.backgroundCompletionHandler = completionHandler
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        Logger.sharedInstance.demarcate()
        Logger.sharedInstance.log("in didReceiveLocalNotification")
        Logger.sharedInstance.demarcate(withDate: false)
    }


}

