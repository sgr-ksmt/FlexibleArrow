//
//  FlexibleArrow.swift
//  FlexibleArrowTest
//
//  Created by Suguru Kishimoto on 1/16/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit

public class FlexibleArrow: UIView {
    private var _direction: FlexibleArrowDirection = .up
    public var direction: FlexibleArrowDirection {
        get {
            return _direction
        }
        set {
            if _direction == newValue {
                return
            }
            _direction = newValue
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    public var inset: UIEdgeInsets = .zero
    public var isRoundedCap: Bool = true
    public var color: UIColor = .darkGray
    public var lineWidth: CGFloat = 4.0
    public var head: CGFloat = 8.0
    public var animation: FlexibleArrowAnimation = .default
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(shape)
        return shape
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        prepareShapeLayer()
        drawArrow()
    }
    
    @objc(setDirection:animated:completion:)
    public func set(direction: FlexibleArrowDirection, animated: Bool = false, completion: (() -> Void)? = nil) {
        if _direction == direction {
            return

        }
        _direction = direction
        
        if animated {
            let toPath = arrowPath(with: direction).cgPath
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = toPath
            pathAnimation.duration = animation.duration
            pathAnimation.timingFunction = animation.timingFunction
            pathAnimation.fillMode = kCAFillModeForwards
            pathAnimation.isRemovedOnCompletion = false
            
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                self?.shapeLayer.path = toPath
                self?.shapeLayer.removeAllAnimations()
                completion?()
            }
            self.shapeLayer.add(pathAnimation, forKey: nil)
            CATransaction.commit()
        } else {
            setNeedsLayout()
            layoutIfNeeded()
            completion?()
        }
    }
    
    private func prepareShapeLayer() {
        shapeLayer.frame = UIEdgeInsetsInsetRect(bounds, inset)
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = isRoundedCap ? kCALineCapRound : kCALineCapButt
    }
    
    private func drawArrow() {
        let path = arrowPath(with: direction)
        shapeLayer.path = path.cgPath
    }
    
    private func makeArrowInset() -> UIEdgeInsets {
        let lineWidthHalf = lineWidth / 2.0
        return UIEdgeInsets(
            top: lineWidthHalf,
            left: lineWidthHalf,
            bottom: lineWidthHalf,
            right: lineWidthHalf
        )
    }
    
    private func arrowPath(with direction: FlexibleArrowDirection) -> UIBezierPath {
        let path = UIBezierPath()
        let size = shapeLayer.frame.size
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let arrowInset = makeArrowInset()
        switch direction {
        case .up:
            path.move(to: CGPoint(x: arrowInset.left, y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: max(center.y - head, arrowInset.top * 1.5)))
            path.addLine(to: CGPoint(x: size.width - arrowInset.right, y: center.y))
            
        case .down:
            path.move(to: CGPoint(x: arrowInset.left, y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: min(center.y + head, size.height - arrowInset.bottom * 1.5)))
            path.addLine(to: CGPoint(x: size.width - arrowInset.right, y: center.y))
            
        case .left:
            path.move(to: CGPoint(x: center.x, y: arrowInset.top))
            path.addLine(to: CGPoint(x: max(center.x - head, arrowInset.left * 1.5), y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: size.height - arrowInset.bottom))
            
        case .right:
            path.move(to: CGPoint(x: center.x, y: arrowInset.top))
            path.addLine(to: CGPoint(x: min(center.x + head, size.width - arrowInset.right * 1.5), y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: size.height - arrowInset.bottom))
            
        case .horizontalLine:
            path.move(to: CGPoint(x: arrowInset.left, y: center.y))
            path.addLine(to: center)
            path.addLine(to: CGPoint(x: size.width - arrowInset.right, y: center.y))
            
        case .verticalLine:
            path.move(to: CGPoint(x: center.x, y: arrowInset.top))
            path.addLine(to: center)
            path.addLine(to: CGPoint(x: center.x, y: size.height - arrowInset.bottom))
        }
        return path
    }
}
