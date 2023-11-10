//
//  CameraViewController.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 30/10/2023.
//

import UIKit
//import SwiftUI
import AVFoundation
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var draggableRectangleView = DraggableRectangleView()
    var firstRotate = true
    var savedCourtPositions: [CALayer] = []
    
    // Detector
    private var videoOutput = AVCaptureVideoDataOutput()
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    
    var screenRect: CGRect = UIScreen.main.bounds
    var session: AVCaptureSession?
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    let output = AVCaptureVideoDataOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    var buttonPressed: Bool = false {
        didSet {
            savedCourtPositions = draggableRectangleView.getDragLayers()
            print(savedCourtPositions)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
        setupDetector()
        setupDetectionLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gestureRecognizer = UIGestureRecognizer()
        gestureRecognizer.delaysTouchesBegan = false
        gestureRecognizer.delaysTouchesEnded = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.previewLayer.frame = UIScreen.main.bounds
        
        // update field
        screenRect = UIScreen.main.bounds
        
        previewLayer.frame = screenRect
        detectionLayer.frame = screenRect
        
        if firstRotate {
            setupCourtDraw()
            firstRotate = false
        }
        
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            break
        case .landscapeLeft:
            previewLayer.connection?.videoRotationAngle = 0
        case .landscapeRight:
            previewLayer.connection?.videoRotationAngle = 180
        default:
            break
        }
    }
    
    private func setupCourtDraw() {
        // Create a DraggableRectangleView instance
        draggableRectangleView = DraggableRectangleView(frame: screenRect)
        draggableRectangleView.backgroundColor = UIColor.clear
        draggableRectangleView.layer.zPosition = 1
        view.addSubview(draggableRectangleView)
    }
    
    //MARK: Camera setup
    
    private func setupCamera() {
        let session = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput)
        }
        
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
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
        
        self.view.layer.addSublayer(previewLayer)
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
}
