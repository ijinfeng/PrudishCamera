//
//  AnchorLayer.swift
//  PrudishCamera
//
//  Created by jinfeng on 2021/8/17.
//

import Foundation
import UIKit

/// 十字锚点
class AnchorLayer: CALayer {
    var type: Setting.AnchorType = Setting.AnchorType.threePoint
    
    lazy var leftEye = CALayer()
    lazy var rightEye = CALayer()
    lazy var mouth = CALayer()
    
    lazy var crossv = CALayer()
    lazy var crossh = CALayer()
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
        isHidden = true
        
        let color = UIColor.white.cgColor
        
        if type == .cross {
            addSublayer(crossv)
            addSublayer(crossh)
            
            crossv.backgroundColor = color
            crossh.backgroundColor = crossv.backgroundColor
            
            crossv.frame = CGRect(x: 0, y: 0, width: 5, height: 30)
            crossh.frame = CGRect(x: 0, y: 0, width: 30, height: 5)
        } else {
            addSublayer(leftEye)
            addSublayer(rightEye)
            addSublayer(mouth)
            
            leftEye.backgroundColor = color
            rightEye.backgroundColor = leftEye.backgroundColor
            mouth.backgroundColor = leftEye.backgroundColor
            
            leftEye.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
            rightEye.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
            mouth.frame = CGRect(x: 0, y: 0, width: 10, height: 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAnchor(_ faceFeature: CIFaceFeature) {
        if faceFeature.hasLeftEyePosition || faceFeature.hasRightEyePosition || faceFeature.hasMouthPosition {
            isHidden = false
            // 计算出两眼之间的中心点
            var left = faceFeature.leftEyePosition
            var right = faceFeature.rightEyePosition
            var m = faceFeature.mouthPosition
            
            
            var transform = CGAffineTransform.identity.scaledBy(x: -1, y: -1)
            transform = transform.translatedBy(x: 0, y: -UIScreen.main.bounds.size.height)
            
            left = __CGPointApplyAffineTransform(left, transform)
            right = __CGPointApplyAffineTransform(right, transform)
            m = __CGPointApplyAffineTransform(m, transform)
            
            if type == .cross {
                let center = CGPoint(x: (m.x - (right.x - left.x) / 2.0) / 2.0, y: (m.y - (right.y - left.y) / 2.0) / 2.0)
                crossh.position = center
                crossv.position = center
                print("h=\(crossh.frame), v=\(crossv.frame)")
            } else {
                leftEye.position = left
                rightEye.position = right
                mouth.position = m
//                print("left=\(left), right=\(right), mouth=\(m)")
            }
        } else {
            isHidden = true
            
        }
    }
}
