//
//  AppDelegate.swift
//  LvMP
//
//  Created by Jinu Kim on 2018. 9. 10..
//  Copyright © 2018년 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        let state = defaults.object(forKey: "launch") as? Bool ?? false
        if !state {
            let realm = try! Realm()
            let emptyArtist = Artist(name: "아티스트가 없습니다.")
            let emptyAlbum = Album(name: "앨범이 없습니다.", artist: emptyArtist)
            do {
                try realm.write {
                    realm.add(emptyArtist)
                    realm.add(emptyAlbum)
                }
                defaults.set(true, forKey: "launch")
                defaults.set(emptyArtist.id, forKey: "emptyArtistID")
                defaults.set(emptyAlbum.id, forKey: "emptyAlbumID")
            } catch {
                let alert = warringAlert(title: "에러가 발생했습니다", message: "앱을 다시 실행해주세요")
                self.window?.rootViewController?.present(alert, animated: true)
            }
        }
        SocketIOManager.shared.connect()
        
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SocketIOManager.shared.disconnect()
    }


}

