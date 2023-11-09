//
//  HomeView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var settings: Settings
    @State var goToSettings = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Laatste Analyses")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(1...6, id: \.self) { index in
                                    Rectangle()
                                        .frame(width: 144, height: 100)
                                        .foregroundColor(.gray.opacity(0.4))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                NavigationLink(value: 1) {
                    Text("Start analyse")
                }
                .buttonStyle(ButtonModifier())
            }
            .navigationTitle("Volley Stats")
            .navigationDestination(for: Int.self) { value in
                if settings.tooltipsEnabled {
                    PositionInstruction()
                } else {
                    CustomCameraView()
                        .onAppear(perform: {
                            lockOrientation()
                        })
                        .navigationBarBackButtonHidden()
                }
            }
            .navigationDestination(isPresented: $goToSettings, destination: {
                SettingsView()
            })
            .toolbar {
                Button(action: {
                    goToSettings = true
                }, label: {
                    Image(systemName: "gear")
                })
            }
        }
        .onAppear() {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
    }
    
    private func lockOrientation() {
        // Forcing the rotation to landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        // And making sure it stays that way
        AppDelegate.orientationLock = .landscape
    }
}

#Preview {
    HomeView()
        .environmentObject(Router())
        .environmentObject(Settings())
}
