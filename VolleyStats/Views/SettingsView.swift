//
//  SettingsView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 09/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $settings.tooltipsEnabled, label: {
                    Text("Tooltips")
                })
            } header: {
                Text("Instructies")
            }
        }
        
        .navigationTitle("Instellingen")
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(Settings())
    }
}
