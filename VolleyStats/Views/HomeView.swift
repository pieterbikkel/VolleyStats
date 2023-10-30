//
//  HomeView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 11/10/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
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
                
                NavigationLink {
                    PositionInstruction()
                } label: {
                    Text("Start analyse")
                }
                .buttonStyle(ButtonModifier())

                
                
            }
            .navigationTitle("Volley Stats")
        }
        .onAppear() {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                        AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }
    }
}

#Preview {
    HomeView()
}
