///
//  AppDelegate.swift
//  PYT
//
//  Created by Niteesh on 04/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

var bucketListTotalCount = "0"




import UIKit
//import Lock
import CoreData
import IQKeyboardManager
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import AWSS3

var profileUserData = NSMutableDictionary()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?
    var window2 = UIWindow?()
    
   let storyboard = UIStoryboard(name: "Main", bundle: nil)
   var searchResult:NSMutableDictionary!
    
    
    
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        /*
         Store the completion handler.
         */
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    

    
  
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
//        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        
//        
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
        

        
         registerForPushNotifications(application)
        
        
        
        
        
        
        
        // Override point for customization after application launch.
        
        //hide status bar
       // application.statusBarHidden = true
     
        //PYTtechnologies for testing by client
        //GMSServices.provideAPIKey("AIzaSyBDenikfv42wDKexBdljrjKNex8UHmT-bU")
       // GMSPlacesClient.provideAPIKey("AIzaSyBDenikfv42wDKexBdljrjKNex8UHmT-bU")
        
        
        //niteesh.appsmaven for testing by Developer
        GMSPlacesClient.provideAPIKey("AIzaSyB9TowwPbfXzVrkmKbKB5qBkc4luwc-qck")
        GMSServices.provideAPIKey("AIzaSyB9TowwPbfXzVrkmKbKB5qBkc4luwc-qck")
      
        
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
       let defaults = NSUserDefaults.standardUserDefaults()
//        let firstLaunch = defaults.boolForKey("tutorialLaunch")
//        
//        
//        
//        if firstLaunch {
//            
//            
//        }
//        else
//        {
//            
//
//        }
        
        
        //iqkeyboard manager
         IQKeyboardManager.sharedManager().enable = true
         IQKeyboardManager.sharedManager().keyboardDistanceFromTextField=90
        
        
            // self.window!.backgroundColor = UIColor (red: 12, green: 123.0, blue: 12.0, alpha: 0.0)
            application.statusBarStyle = .LightContent
        
        
       
        
     
        
        //fabric management
        Fabric.with([Crashlytics.self])
        
        
        
        
        ///////////////////--------- call the api to get the story count and user profile--------///////////////
        
        
        
        
        
        
    
        
        
        
        
        
        
        //Auto loging into app
        
       
        
        let tabledata = defaults.arrayForKey("arrayOfIntrest")
        if let name = defaults.stringForKey("userLoginId") // check fb access token
        {
            print(name)
            
            if name == ""  //if fbaccesstoken is empty check instagram token
            {
                
            }
        else
        {
            
            if tabledata?.count<1 {
                
                
                
                
                
                // if not select any intrest show intrest screen
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                    
                    
                    let storyboard=UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let joinObj=storyboard.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
                    let navigationController=self.window?.rootViewController as! UINavigationController
                    navigationController.navigationBar.hidden=true
                    navigationController.setViewControllers([joinObj], animated: true)
                    
                    
                    
                })
                
                
                
            }
            else
            {
                
                
                if  let uId = defaults .stringForKey("userLoginId"){
                    print(uId)
                    if uId != "" {
                        
                        
                        
                        
                        
                        let objt = storyCountClass()
                        let objt2 = UserProfileDetailClass()
                        ///story count
                        // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                        //dispatch_async(dispatch_get_main_queue(), {
                        print("This is run on the background queue")
                        
                        objt.postRequestForcountStory("userId=\(uId)")
                        
                        // dispatch_async(dispatch_get_main_queue(), {
                        
                        // })
                        
                        
                        
                        ///User profile
                        //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                        objt2.postRequestForGetTheUserProfileData("userId=\(uId)")
                        // })
                        
                        
                        
                        
                        
                        
                    }
                    
                }
                
                

                
                
                
                
                
                
                
                let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                
            
                
            }
            
        }
        }
       // else
//        {
//            
//            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController")
//            
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//        }
        
        
       
        
        
        
        /////////////////////----- Tab bar text color to white color always----------/////
        
        UITabBar.appearance().tintColor = UIColor .clearColor()
        // Add this code to change StateNormal text Color,
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor .whiteColor()], forState: .Normal)
        // then if StateSelected should be different, you should add this code
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor .whiteColor()], forState: .Selected)

       
        
        
        
        
        
        
        return true
    }

    
    
    
    
    
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        
        print("URL : \(url)")
        if(url.scheme.isEqual("fb1726736034214210")) {
            print("Facebook url scheme")
            
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
            
        } else {
            
            print("another url scheme")
           // let lock = MyApplication.sharedInstance.lock
           // lock.handleURL(url, sourceApplication: sourceApplication)
            
            return true
            
            
        }
        
        
        
        
       

    }
    
    
    
    
    
    //MARK: Notification Start
    //MARK:
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print(error)
    }
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        print(deviceToken.description)
        
        var myToken=deviceToken.description
        myToken=myToken.stringByReplacingOccurrencesOfString("<", withString: "")
        myToken=myToken.stringByReplacingOccurrencesOfString(">", withString: "")
        myToken=myToken.stringByReplacingOccurrencesOfString(" ", withString: "")
        print("DEVICE TOKEN = \(myToken)")
        //userDefaults.setObject(myToken, forKey: "deviceToken")
        
        
    }
    
    
    
    
    
    
    
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert ], categories: nil)
        
        
        
        application.registerUserNotificationSettings(notificationSettings)
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        
        //        let msg = "Awf"
        //        let msg2 = userInfo["aps"]!["alert"] as! String
        //        let iduse = userInfo["userid"] as? String
        
        
        
        
        
        
        
        //userInfo["aps"]!["badge"] as! Int
        
        
        if application.applicationState == .Active {
            
            
            application.applicationIconBadgeNumber = 1
            
            
            HDNotificationView.showNotificationViewWithImage(UIImage(named: "notification")!, title: "Hiii MEssage", message: "testing Notification", isAutoHide: true, onTouch: {() -> Void in
            })
            
            
        }
        else
        {
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            
            
            
            initialViewController.selectedIndex = 3
            
            //navController.pushViewController(myViewController, animated: true)
            
            
            application.applicationIconBadgeNumber = 0
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    func application(application: UIApplication, didReceiveRemoteNotificationuserInfo: [NSObject : AnyObject])
    {
        print(didReceiveRemoteNotificationuserInfo)
        
    }
    
    
    
    
    //MARK: Notification End
    
    
   
    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
      
       
      
        
        let notification = UILocalNotification()
        notification.alertAction = "Pyt test notification"
        notification.alertBody = "The Application is running in background state"
        notification.fireDate = NSDate(timeIntervalSinceNow: 3)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
       
        
        
    }

    
        
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
           FBSDKAppEvents.activateApp()
        
       
        
        
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        ////Disconnect the socket when app will be in background
        SocketIOManager.sharedInstance.closeConnection()
        
    
    }

    
    
   
   
    
    
    

}

