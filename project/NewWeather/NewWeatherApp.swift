//
//  NewWeatherApp.swift
//  NewWeather
//
//  Created by 김형관 on 2023/04/25.
//

import SwiftUI

@main
struct NewWeatherApp: App {
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
            
        }
    }
}

