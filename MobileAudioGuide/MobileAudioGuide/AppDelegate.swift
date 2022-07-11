//
//  AppDelegate.swift
//  MobileAudioGuide
//
//  Created by Настя on 15.05.2022.
//

import UIKit
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let priceManager = PriceManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAudioSession()
        authNotification()
        UNUserNotificationCenter.current().delegate = self
        scheduleNotification()
        
        priceManager.getPricesForInApps(inAppsIDs: [InAppProducts.firstTour.rawValue, InAppProducts.allTours.rawValue])
        
        PurchaseManager.shared.setupPurchases { success in
            if success {
                PurchaseManager.shared.getAllProducts()
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Setting up AVAudiSession
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Scheduled notification
    private func authNotification() {
        let options: UNAuthorizationOptions = [.sound, .badge, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    private func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Will you visit Istanbul soon?🔥"
        content.body = "Cover all the most interesting things at your own pace and without expensive guides"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let date = Date(timeIntervalSinceNow: 24 * 60 * 3600)
        let triggerDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .list, .banner])
    }
}
