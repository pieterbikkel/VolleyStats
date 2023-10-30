//
//  FullScreenModifier.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 23/10/2023.
//

import Foundation
import SwiftUI

struct FullScreenModalViewModifier<FullScreenView: View>: ViewModifier{
    var fullscreenView: FullScreenView?
    func body(content: Content) -> some View {
        if let view = fullscreenView {
            return AnyView(content.overlay(CameraViewControllerWrapper(content: view)))
        }else{
            return AnyView(content)
        }
    }
}

extension View{
    public func fullscreen<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View{
        let view = item.wrappedValue == nil ? nil : AnyView(content(item.wrappedValue!))
        return modifier(FullScreenModalViewModifier(fullscreenView: view))
    }
    public func fullscreen<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View{
        let view = isPresented.wrappedValue ? AnyView(content()) : nil
        return modifier(FullScreenModalViewModifier(fullscreenView: view))
    }
}
