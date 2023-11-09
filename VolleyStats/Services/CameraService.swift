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
        checkPermissions(completion: completion)
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
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session
        previewLayer.connection?.videoRotationAngle = 0
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
        
        self.session = session
    }
    
    func captureVideo(with settings: [String : Any] = [:]) {
        output.videoSettings = settings
    }
}
