//
//  HomeView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var settings: Settings
    @State var goToSettings = false
    @State var showPicker = false
    @State var assetURL: AVAsset?
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 20) {
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Laatste Analyses")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            LazyHStack {
//                                ForEach(1...6, id: \.self) { index in
//                                    Rectangle()
//                                        .frame(width: 144, height: 100)
//                                        .foregroundColor(.gray.opacity(0.4))
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
                
                Spacer()
                
                Button {
                    showPicker.toggle()
                } label: {
                    Text("Analyseer video")
                        .frame(minWidth: 190)
                }
                .buttonStyle(ButtonModifier())
                
                NavigationLink(value: 1) {
                    Text("Start analyse")
                        .frame(minWidth: 190)
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
            .fullScreenCover(isPresented: $showPicker) {
                UIImagePickerControllerRepresentable(assetURL: $assetURL, showScreen: $showPicker)
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
