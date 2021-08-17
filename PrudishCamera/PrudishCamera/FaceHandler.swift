//
//  FaceHandler.swift
//  PrudishCamera
//
//  Created by jinfeng on 2021/8/17.
//

import Foundation
import UIKit
import Vision

class FaceHandler {
    
    var anchor: CALayer? {
        didSet {
            anchor?.borderWidth = 1
            anchor?.borderColor = UIColor.red.cgColor
            anchor?.isHidden = false
            eye.backgroundColor = UIColor.red.cgColor
            anchor?.addSublayer(eye)
        }
    }
    
    var eye = CALayer()
    
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
                self.anchor?.frame = CGRect(x: point.x, y: point.y, width: 20, height: 20)
                print("origin=\(rect),rect=\(self.anchor!.frame)")
            }
        }
    }
}
