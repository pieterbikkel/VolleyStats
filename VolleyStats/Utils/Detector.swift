//
//  Detector.swift
//  BallTracking
//
//  Created by Pieter Bikkel on 25/10/2023.
//

import UIKit
import AVFoundation
import Vision

extension CameraViewController {
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: "ModelV3", withExtension: "mlmodelc")

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print("Error 😵" + error.localizedDescription)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { return }
            
            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let tranformBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(tranformBounds)
            
            detectionLayer.addSublayer(boxLayer)
        }
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = UIColor.green.cgColor
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Handler to perform a request on the buffer
        
        do {
            try imageRequestHandler.perform(self.requests) // Schedule vision requests to be performed
        } catch let error {
            print("Error 😵" + error.localizedDescription)
        }
    }
    
    func setupDetectionLayer() {
        detectionLayer = CALayer()
        detectionLayer.borderColor = UIColor.orange.cgColor
        detectionLayer.borderWidth = 2
        detectionLayer.frame = UIScreen.main.bounds
        
        self.view.layer.addSublayer(detectionLayer)
    }
}
