//
//  AppDelegate.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-25.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FIREBASE
        FirebaseApp.configure()
        
        //KEYBOARDMANGER
        IQKeyboardManager.shared.enable = true
        
        //NOTIFICATION
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                print("SOMETHING WENT WRONG")
            }
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
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
        if (application.applicationIconBadgeNumber > 0) {
            application.applicationIconBadgeNumber = 0
            print("RECEIVE NOTIFICATION - APP")
            self.createNotification()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        application.applicationIconBadgeNumber = 0
        print("RECEIVE NOTIFICATION - OPEN")
        self.createNotification()
    }
    
    func createNotification() {
        
        if let frequence = ProfileManager.getFrequence() {
        
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("notification_title", comment: "")
            content.body = NSLocalizedString("notification_body", comment: "")
            content.sound = UNNotificationSound.default
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
            
            let gregorian = Calendar(identifier: .gregorian)
            let today = Date()
            var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: today)
            
            // Change the time to value saved
            components.day = getFrequenceDays(frequence)
            
            let date = gregorian.date(from: components)!
            
            let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
            
            let identifier = "BabySelfieLocalNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("SOMETHING WENT WRONG")
                }
            })

        }
        
        
    }


}

