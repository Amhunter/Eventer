//
//  AppDelegate.swift
//  Eventer
//
//  Created by Grisha on 16/11/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var client:MSClient?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        //self.window?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
        UITabBar.appearance().barTintColor = ColorFromCode.tabBackgroundColor()
        //UITabBar.appearance().tintColor = ColorFromCode.standardBlueColor()
        
//        UITabBarItem.appearance().setTitleTextAttributes([ColorFromCode.tabForegroundColor() : NSForegroundColorAttributeName], forState: UIControlState.Normal)
//        UITabBarItem.appearance().setTitleTextAttributes([ColorFromCode.tabForegroundActiveColor() : NSForegroundColorAttributeName], forState: UIControlState.Highlighted)

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        UITabBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = ColorFromCode.colorWithHexString("#02A8F3")
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().barStyle = UIBarStyle.Black

        
//        
//        self.client = MSClient(
//            applicationURLString:"https://grishagev.azure-mobile.net/",
//            applicationKey:"vKsVuvBOIicyyWdgaYxCHYEISbqemW53"
//        )
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            "kid_W19oFN4H1l",
            withAppSecret: "eb9b242e6a4f49f1969e2c4862c99391",
            usingOptions: nil
        )
        //KCSClient.configureLoggingWithNetworkEnabled(true, debugEnabled: true, traceEnabled: true, warningEnabled: true, errorEnabled: true)
        
        
//        KCSPing.pingKinveyWithBlock { (result: KCSPingResult!) -> Void in
//            if result.pingWasSuccessful {
//                NSLog("Kinvey Ping Success")
//            } else {
//                NSLog("Kinvey Ping Failed")
//            }
//        }
        
        
        if (KCSUser.activeUser() != nil){
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as UIViewController!
        }
        else
        {
            let rootController:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Signup View") as! SignupViewController
            let navigation:SignupNavigationController = SignupNavigationController(rootViewController: rootController)
            self.window?.rootViewController = navigation as UIViewController
        }
        
        
//        //Amazon Cognito
//        var credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.APNortheast1, identityPoolId: "us-east-1:69da87c7-9088-41ab-91bf-c559c7c75420")
//        var configuration:AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.APNortheast1, credentialsProvider: credentialsProvider)
//        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
//        
//        //Mobile Analytics
//        var mobileAnalyticsConfiguration:AWSMobileAnalyticsConfiguration = AWSMobileAnalyticsConfiguration()
//        mobileAnalyticsConfiguration.transmitOnWAN = true
//        
//        var analytics = AWSMobileAnalytics(forAppId: "1f2038e2e266412a9f9bb3659494ed48", configuration: mobileAnalyticsConfiguration, completionBlock: nil)
//        
//        //call to aws  services
//        let dynamoDB = AWSDynamoDB.defaultDynamoDB()
//        let listTableInput = AWSDynamoDBListTablesInput()
//        dynamoDB.listTables(listTableInput).continueWithBlock{
//            (task: BFTask!) -> AnyObject! in
//            let listTablesOutput = task.result as AWSDynamoDBListTablesOutput
//            
//            for tableName : AnyObject in listTablesOutput.tableNames {
//                println("\(tableName)")
//            }
//            return nil
//        }
//        
        
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Gevorkyan.testt" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("testt", withExtension: "momd")!
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
            
            dict[NSUnderlyingErrorKey] = error as NSError
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

}

