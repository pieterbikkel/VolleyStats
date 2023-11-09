//
//  VolleyStatsApp.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI

@main
struct VolleyStatsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var router = Router()
    @StateObject var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(settings)
        }
    }
}
