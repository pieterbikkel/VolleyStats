//
//  CameraViewController.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 30/10/2023.
//

import UIKit
import SwiftUI
import AVFoundation

class CameraViewController: UIViewController {
    
    var previewLayer: AVCaptureVideoPreviewLayer
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    var draggableRectangleView = DraggableRectangleView()
    var firstRotate = true
    var savedCourtPositions: [CALayer] = []
    
    var buttonPressed: Bool = false {
        didSet {
            savedCourtPositions = draggableRectangleView.getDragLayers()
            print(savedCourtPositions)
        }
    }
    
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
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
        draggableRectangleView = DraggableRectangleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        draggableRectangleView.backgroundColor = UIColor.clear
        draggableRectangleView.layer.zPosition = 1
        view.addSubview(draggableRectangleView)
    }
}
