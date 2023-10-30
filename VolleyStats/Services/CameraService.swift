//
//  CameraService.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 30/10/2023.
//

import Foundation
import AVFoundation

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    let output = AVCaptureVideoDataOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCaptureVideoDataOutputSampleBufferDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func captureVideo(with settings: [String : Any] = [:]) {
        output.videoSettings = settings
    }
}
