//
//  SocialMusicMediaAppApp.swift
//  SocialMusicMediaApp
//
//  Created by Christopher Sandoval Terry on 8/22/24.
//

import SwiftUI
import Firebase


@main
struct SocialMusicMediaAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
