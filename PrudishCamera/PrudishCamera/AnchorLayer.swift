//
//  AnchorLayer.swift
//  PrudishCamera
//
//  Created by jinfeng on 2021/8/17.
//

import Foundation
import UIKit
import Vision
import AVFoundation

/// 十字锚点
class AnchorLayer: CALayer {
    var type: Setting.AnchorType = Setting.AnchorType.cross
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
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
        
        let color = UIColor.black.cgColor
        
        if type == .cross {
            addSublayer(crossv)
            addSublayer(crossh)
            
            crossv.backgroundColor = color
            crossh.backgroundColor = crossv.backgroundColor
        } else {
            addSublayer(leftEye)
            addSublayer(rightEye)
            addSublayer(mouth)
            
            leftEye.backgroundColor = color
            rightEye.backgroundColor = leftEye.backgroundColor
            mouth.backgroundColor = leftEye.backgroundColor
        }
        
        leftEye.borderWidth = 1
        leftEye.borderColor = color
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
    
    
    
    func handleImage(_ ciImage: CIImage) {
        let vnRequest = VNImageRequestHandler(ciImage: ciImage)
        let faceRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            guard let results = request.results else {
                return
            }
            self.handleFaces(results)
        }
        try? vnRequest.perform([faceRequest])
    }
    
    private func handleFaces(_ faces: [Any]) {
        for face in faces {
            guard let observation = face as? VNFaceObservation else {
                break
            }
            guard let faceLandmark = observation.landmarks else {
                break
            }
           guard let point = faceLandmark.leftEye?.normalizedPoints.first else {
                return
            }
            
            let rect = observation.boundingBox
            let screen = UIScreen.main.bounds
            let w = rect.size.width * screen.size.width
            let h = rect.size.height * screen.size.height
            let x = rect.origin.x * screen.size.width
            let y = screen.size.height -  rect.origin.y * screen.size.height - h
            

            DispatchQueue.main.async {
                self.leftEye.frame = self.convert(rect: rect)
                print("rect=\(rect), eye=\(self.leftEye.frame), hidden=\(self.leftEye.isHidden)")
            }
        }
    }
    
    private func convert(rect: CGRect) -> CGRect {
        guard let convertLayer = previewLayer else {
            return CGRect.zero
        }
        
        let cr = convertLayer.layerRectConverted(fromMetadataOutputRect: rect)
        return CGRect(x: UIScreen.main.bounds.size.width - cr.origin.x - cr.size.width, y: cr.origin.y, width: cr.size.width, height: cr.size.height)
      }
    
    private func convert(point: CGPoint) -> CGPoint {
        guard let convertLayer = previewLayer else {
            return CGPoint.zero
        }
        
        return convertLayer.layerPointConverted(fromCaptureDevicePoint: point)
    }
}
