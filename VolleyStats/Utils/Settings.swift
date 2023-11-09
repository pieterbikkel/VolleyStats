//
//  Settings.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 09/11/2023.
//

import Foundation

class Settings: ObservableObject {
    @Published var tooltipsEnabled: Bool = false
    let cameraService = CameraService()
}
