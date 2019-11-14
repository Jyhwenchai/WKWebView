//
//  ProgressView.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/12.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = 5.0
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.0
        
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        progressLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.size.width, height: progressLayer.lineWidth))
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: bounds.size.width, y: 0))
        progressLayer.path = path.cgPath
    }
    
    public func animate(with percentage: Double) {
        let animate = CABasicAnimation(keyPath: "strokeEnd")
        animate.fromValue = progressLayer.strokeEnd
        animate.byValue = percentage
        animate.duration = 0.15
        animate.fillMode = .forwards
        animate.isRemovedOnCompletion = false
        animate.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        progressLayer.add(animate, forKey: nil)
    }

}
