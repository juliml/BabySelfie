//
//  AppDelegate.swift
//  BabySelfie
//
//  Created by Juliana Lima on 3/29/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import IQKeyboardManagerSwift

let FirebaseUrl = "https://babyselfie.firebaseio.com/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //FACEBOOK API
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //KEYBOARDMANGER
        IQKeyboardManager.sharedManager().enable = true
        
        //NOTIFICATION
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
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
        FBSDKAppEvents.activateApp()
        if (application.applicationIconBadgeNumber > 0) {
            application.applicationIconBadgeNumber = 0
            print("recebeu notificação app")
            self.createNotification();
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        print("recebeu notificação open")
        self.createNotification();
    }
    
    func createNotification() {
        
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let frequence = userDefaults.valueForKey("frequence") {
            
            dateComponent.day = 7*(frequence as! NSString).integerValue
            let nextDays = calendar.dateByAddingComponents(dateComponent, toDate: today, options: [])

            let notification = UILocalNotification()
            notification.fireDate = nextDays
            notification.alertBody = "Olá! Vamos tirar uma foto do seu bebê?"
            notification.alertAction = "preparar a foto!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        
        
        
    }


}

