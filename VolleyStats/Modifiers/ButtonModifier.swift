//
//  ButtonModifier.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 13/10/2023.
//

import SwiftUI

struct ButtonModifier: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 90)
            .padding()
            .background(Color(.accent))
            .cornerRadius(12)
    }
}
