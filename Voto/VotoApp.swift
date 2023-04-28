//
//  VotoApp.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct VotoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var uploadVM = UploadViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var upvoteVM = UpvoteViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(uploadVM)
                .environmentObject(userVM)
                .environmentObject(upvoteVM)
        }
    }
}
