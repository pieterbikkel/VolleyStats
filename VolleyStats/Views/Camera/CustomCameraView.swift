//
//  CustomCameraView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 30/10/2023.
//

import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var settings: Settings
    @State var buttonPressed = false
    
    // Camera
    
//    @Binding var capturedVideo: AVCaptureVideoDataOutput?
    
    // Messages
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var messages = ["Zorg dat je eigen spelerskant volledig in zicht is",
                    "Zorg dat de spelerskant overeenkomt met de punten"]
    @State var showCourtComformationButton = false
    @State var remainingTime = 15
    @State var currentMessage = 0
    @State var animationValues: [Bool] = Array(repeating: false, count: 10)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            CameraView(buttonPressed: $buttonPressed)  { result in
                switch result {
                case .success(let video):
                    print("Wow dit gaat werken \(video)")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    if showCourtComformationButton {
                        Button {
                            // TODO: print layers
                            buttonPressed = true
                            print("TAP \(buttonPressed)")
                        } label: {
                            Text("Zet veld vast")
                        }
                        .buttonStyle(ButtonModifier())
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Text(messages[currentMessage])
                        .fontWeight(.semibold)
                        .padding()
                        .background(.white.opacity(0.76))
                        .cornerRadius(20)
                        .offset(y: animationValues[0] ? 0 : -100)
                }
                .padding(.top, 24)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                        // Unlocking the rotation when leaving the view
                        AppDelegate.orientationLock = .portrait
                        router.reset()
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.76))
                            .foregroundColor(Color.black)
                            .cornerRadius(20)
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button {
                //TODO: Record video
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                }
            }
            .zIndex(1)
            .opacity(0)
        }
        .onReceive(timer, perform: { _ in
            notificationScheduler()
        })
    }
    
    private func notificationScheduler() {
        if !settings.tooltipsEnabled {
            remainingTime = 1
        }
        
        if remainingTime <= 1 {
            showCourtComformationButton = true
        } else {
            if remainingTime <= 14 {
                withAnimation(.spring) {
                    animationValues[0] = true
                }
            }
            
            if remainingTime <= 8 {
                withAnimation(.spring) {
                    animationValues[0] = false
                    currentMessage = 1
                }
            }
            
            if remainingTime <= 7 {
                withAnimation(.spring) {
                    animationValues[0] = true
                }
            }
            
            if remainingTime <= 2 {
                withAnimation(.spring) {
                    animationValues[0] = false
                }
            }
            
            remainingTime -= 1
        }
    }
}

#Preview {
    CustomCameraView()
        .environmentObject(Router())
        .environmentObject(Settings())
}
