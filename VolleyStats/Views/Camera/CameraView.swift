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
    
    let cameraService: CameraService
    @Binding var buttonPressed: Bool
    let didFinishProcessingVideo: (Result<AVCaptureVideoDataOutput, Error>) -> ()
    
    func makeUIViewController(context: Context) -> CameraViewController {
        cameraService.start(delegate: context.coordinator) { err in
            if let err = err {
                didFinishProcessingVideo(.failure(err))
                return
            }
        }
        
        let viewController = CameraViewController(previewLayer: self.cameraService.previewLayer)
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingVideo: didFinishProcessingVideo)
    }
    
    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {
        self.cameraService.previewLayer.frame = UIScreen.main.bounds
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
