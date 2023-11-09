//
//  DraggableRectangleLayer.swift
//  Court Detection
//
//  Created by Pieter Bikkel on 17/10/2023.
//

import UIKit

class DraggableRectangleView: UIView {
    
    private var dragLayers: [CALayer] = []
    private var lines: [CAShapeLayer] = []
    private let touchExpansionMargin: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDraggableLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDraggableLayers() {
        for _ in 1...4 {
            let dragLayer = CALayer()
            dragLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            dragLayer.backgroundColor = UIColor.blue.cgColor
            dragLayer.cornerRadius = 10
            dragLayer.masksToBounds = true
            layer.addSublayer(dragLayer)
            dragLayers.append(dragLayer)
        }
        
        // Set initial positions for the draggable points
        updateDraggableLayersPositions()
        
        // Create lines between the circles
        for _ in 1...4 {
            let line = CAShapeLayer()
            line.strokeColor = UIColor.blue.cgColor
            line.lineWidth = 2
            layer.addSublayer(line)
            lines.append(line)
        }
        updateLines()
    }
    
    private func updateDraggableLayersPositions() {
        // Update positions based on your requirements
        // For example, set the positions in a rectangle formation
        // You can customize these positions as per your needs
        let screenRect = UIScreen.main.bounds.size
        
        dragLayers[0].position = CGPoint(x: screenRect.width / 2 - 200, y: screenRect.height / 2 - 75)
        dragLayers[1].position = CGPoint(x: screenRect.width / 2 + 200, y: screenRect.height / 2 - 75)
        dragLayers[2].position = CGPoint(x: screenRect.width / 2 + 200, y: screenRect.height / 2 + 75)
        dragLayers[3].position = CGPoint(x: screenRect.width / 2 - 200, y: screenRect.height / 2 + 75)
    }
    
    private func updateLines() {
        // Update lines to connect the circles
        let path = UIBezierPath()
        path.move(to: dragLayers[0].position)
        path.addLine(to: dragLayers[1].position)
        path.addLine(to: dragLayers[2].position)
        path.addLine(to: dragLayers[3].position)
        path.close()
        
        for (_, line) in lines.enumerated() {
            line.path = path.cgPath
            line.fillColor = UIColor.clear.cgColor
            // Adjust line position if necessary
            line.position = CGPoint(x: 0, y: 0)
            line.zPosition = -1  // Draw lines below circles
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            touch.gestureRecognizers?.first?.delaysTouchesBegan = false
            touch.gestureRecognizers?.first?.delaysTouchesEnded = false
            let touchLocation = touch.location(in: self)
            for (_, layer) in dragLayers.enumerated() {
                let touchRect = CGRect(x: layer.frame.minX - touchExpansionMargin,
                                       y: layer.frame.minY - touchExpansionMargin,
                                       width: layer.frame.width + 2 * touchExpansionMargin,
                                       height: layer.frame.height + 2 * touchExpansionMargin)
                if touchRect.contains(touchLocation) {
                    layer.position = touchLocation
                    updateLines()
                    break
                }
            }
        }
    }
}
