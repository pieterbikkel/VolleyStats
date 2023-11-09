//
//  PositionInstruction.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI
import AVFoundation

struct PositionInstruction: View {
    // Animation properties
    @State private var animationValues: [Bool] = Array(repeating: false, count: 10)
    @State private var openCameraView = false
    @State var capturedVideo: AVCaptureVideoDataOutput? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Stappen tot een succesvolle analyse")
                .font(.title3)
                .fontWeight(.bold)
                
            Text("Zorg dat de camera niet beweegt tijdens de wedstrijd en horizontaal staat opgesteld.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(spacing: 0) {
                // Images
                Image("iphone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 50)
                    .rotationEffect(.degrees(animationValues[0] ? 0 : -90))
                    .offset(y: animationValues[1] ? 0 : -40)
                
                Image("tripod")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 175)
            }
            .padding(.bottom, 16)
            
            Button(action: {
                animationValues = Array(repeating: false, count: 10)
                animate()
            }, label: {
                Image(systemName: "arrow.clockwise")
            })
            .opacity(animationValues[1] ? 1 : 0)
            
            Spacer()
            
            Button(action: {
                openCameraView = true
            }, label: {
                Text("Volgende")
            })
            .buttonStyle(ButtonModifier())
        }
        .onAppear {
            animate()
        }
        .fullScreenCover(isPresented: $openCameraView, content: {
            CustomCameraView()
                .onAppear(perform: {
                    lockOrientation()
                })
        })
    }
    
    func animate() {
        withAnimation(.easeInOut(duration: 1.6)) {
            animationValues[0] = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    animationValues[1] = true
                }
            }
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
    NavigationView {
        PositionInstruction()
    }
}
