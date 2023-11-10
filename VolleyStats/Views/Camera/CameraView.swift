//
//  CameraView.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 30/10/2023.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    @Binding var buttonPressed: Bool
    let didFinishProcessingVideo: (Result<AVCaptureVideoDataOutput, Error>) -> ()
    
    func makeUIViewController(context: Context) -> CameraViewController {
        
        let viewController = CameraViewController()
        viewController.view.backgroundColor = .black
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingVideo: didFinishProcessingVideo)
    }
    
    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {
        cameraViewController.buttonPressed = buttonPressed
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        let parent: CameraView
        private var didFinishProcessingVideo: (Result<AVCaptureVideoDataOutput, Error>) -> ()
        
        init(_ parent: CameraView,
             didFinishProcessingVideo: @escaping (Result<AVCaptureVideoDataOutput, Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingVideo = didFinishProcessingVideo
        }
        
        func setCourtPoints() {
            
        }
        
        func videoOutput(_ output: AVCaptureVideoDataOutput, didFinishProcessingVideo video: AVCaptureVideoDataOutput, error: Error?) {
            if let error = error {
                didFinishProcessingVideo(.failure(error))
                return
            } else {
                didFinishProcessingVideo(.success(video))
            }
        }
    }
}
