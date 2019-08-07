//
//  AppDelegate.swift
//  LA
//
//  Created by Nguyen Thi Lan Anh on 7/31/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import ChirpConnect

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sdk: ChirpConnect?
    var sdk2: ChirpConnect?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sdk = ChirpConnect(appKey: CHIRP_APP_KEY, andSecret: CHIRP_APP_SECRET)
        sdk2 = ChirpConnect(appKey: CHIRP_APP_KEY, andSecret: CHIRP_APP_SECRET)
        if let sdk = sdk {
            if let error = sdk.setConfig(CHIRP_APP_CONFIG) {
                print(error.localizedDescription)
            }
            if let error = sdk.start() {
                print(error.localizedDescription)
            }
        }
        
        if let sdk2 = sdk2 {
            if let error = sdk2.setConfig(CHIRP_APP_CONFIG) {
                print(error.localizedDescription)
            }
            if let error = sdk2.start() {
                print(error.localizedDescription)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk.stop() {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let sdk2 = sdk2 {
            if sdk2.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk2.stop() {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk.stop() {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let sdk2 = sdk2 {
            if sdk2.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk2.stop() {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let sdk = sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk.start() {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let sdk2 = sdk2 {
            if sdk2.state == CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk2.start() {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let sdk = sdk {
            if sdk.state == CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk.start() {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let sdk2 = sdk2 {
            if sdk2.state == CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk2.start() {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if let sdk = sdk {
            if sdk.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk.stop() {
                    print(error.localizedDescription)
                }
            }
        }
        
        if let sdk2 = sdk2 {
            if sdk2.state != CHIRP_CONNECT_STATE_STOPPED {
                if let error = sdk2.stop() {
                    print(error.localizedDescription)
                }
            }
        }
    }


}

