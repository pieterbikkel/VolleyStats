//
//  SplashScreen.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI

struct SplashScreen: View {
    
    let volleyballSize: CGFloat = 120
    
    // Animation properties
    @State var animationValues: [Bool] = Array(repeating: false, count: 10)
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ZStack {
            // HomeView
            GeometryReader{ proxy in
            
                let size = proxy.size
                
                HomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(y: animationValues[2] ? 0 : (size.height + 50))
            }
            
            // SplashScreen
            ZStack {
                VStack(spacing: 0) {
                    Image("volleyball")
                        .resizable()
                        .frame(width: volleyballSize, height: volleyballSize)
                        .padding(.bottom, 20)
                        .offset(y: animationValues[1] ? 0 : -100)
                        .opacity(animationValues[1] ? 1 : 0)
                    
                    //Logo
                    HStack {
                        Text("Volley")
                            .font(.title)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .kerning(2)
                            .offset(x: animationValues[0] ? 0 : -200)
                            .opacity(animationValues[0] ? 1 : 0)
                        
                        Text("Stats")
                            .font(.title)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .kerning(2)
                            .offset(x: animationValues[0] ? 0 : 200)
                            .opacity(animationValues[0] ? 1 : 0)
                    }
                }
                .opacity(animationValues[2] ? 0 : 1)
//                .offset(y: animationValues[1] ? 100 : 0)
                
            }
            .environment(\.colorScheme, .light)
        }
        .onAppear {
            // Scale effect
            withAnimation(.easeInOut(duration: 0.6)) {
                animationValues[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(duration: 0.4, bounce: 0.6)) {
                    animationValues[1] = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        animationValues[2] = true
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    SplashScreen()
}
