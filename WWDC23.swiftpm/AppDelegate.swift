//
//  AppDelegate.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import UIKit
import AVFoundation
import GameKit
import UserNotifications
import SwiftUI


//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameCenterEnabled = Bool()
    var gameCenterDefaultLeaderboard = String()


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Set up notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [ .alert, .sound]) { (granted, error) in }
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Come back and play Connect 3", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Your Friends are smashing the leaderboards. Come and show the who is the Boss!", arguments: nil)
        
        content.sound = UNNotificationSound (named: UNNotificationSoundName(rawValue: "notification.caf"))
        
        
        
        var dateInfo = DateComponents()
        
        dateInfo.hour = 11
        dateInfo.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        self.authenticateLocalPlayer()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.ambient)))
        
        return true
    }
    
    
    
    /// Attempts to authenticate player for Game Center and load leaderboard
    func authenticateLocalPlayer() {
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            
            // Launch sign-in view controller if player not signed in to Game Center
            
            if (viewController != nil && self.window?.rootViewController?.presentedViewController == nil) {
                self.window?.rootViewController?.present(viewController!, animated: true, completion: nil)
            }
            
            // If player is signed in, load the leaderboard
            
            else if (localPlayer.isAuthenticated) {
                
                self.gameCenterEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier() { (leaderboardID: String?, error: Error?) -> Void in
                    
                    if let error = error {
                        print(error)
                    } else if let leaderboardID = leaderboardID {
                        self.gameCenterDefaultLeaderboard = leaderboardID
                        print("Local player authenticated")
                        print("Default leaderboard: \(leaderboardID)")
                    }
                }
    
            }
            
            // Otherwise, Game Center not enabled (do not load leaderboard)
            
            else {
                self.gameCenterEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "pauseGame"), object: self)
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "resumeGame"), object: self)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

@main
struct SwiftUIConnect: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
            WindowGroup {
                SwiftUIView();
            }
        }
}
