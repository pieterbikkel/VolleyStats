//
//  SourcePicker.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 10/11/2023.
//

import UIKit
import SwiftUI
import AVFoundation

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var assetURL: AVAsset?
    @Binding var showScreen: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: [.video], asCopy: true)
        vc.delegate = context.coordinator
        return vc
    }
    
    // from SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(assetURL: $assetURL, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        
        @Binding var assetURL: AVAsset?
        @Binding var showScreen: Bool

        init(assetURL: Binding<AVAsset?>, showScreen: Binding<Bool>) {
            self._assetURL = assetURL
            self._showScreen = showScreen
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                return
            }
            assetURL = AVAsset(url: url)
            
            guard let assetURL = assetURL else { return }
            
            showScreen = false
        }
        
    }
    
}
