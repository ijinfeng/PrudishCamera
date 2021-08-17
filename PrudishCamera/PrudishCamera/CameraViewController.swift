//
//  CameraViewController.swift
//  PrudishCamera
//
//  Created by JinFeng on 2021/8/4.
//

import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController {
    
    
    private let outputQueue = DispatchQueue.init(label: "ijinfeng.output")
    
    private let session = AVCaptureSession()
    
    private var stopped = false
    
    private var currentMetadataObjects: [AVMetadataObject]?
    
//    private let anchroLayer = AnchorLayer()
    private let anchroLayer = CALayer()
    
    private let faceHandler = FaceHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDevice()
    }
    
    
    private func setupDevice() {
        if session.canSetSessionPreset(.iFrame1280x720) {
            session.canSetSessionPreset(.iFrame1280x720)
        }
        
        
        let discoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        guard let device = discoverySession.devices.first else {
            return
        }
        
        // Back Camera
        print(device.localizedName)
        // com.apple.avfoundation.avcapturedevice.built-in_video:0
        print(device.modelID)
        
        print(device.position)
        do {
            let deviceInput = try AVCaptureDeviceInput.init(device: device)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: outputQueue)
            output.alwaysDiscardsLateVideoFrames = true
            
            session .beginConfiguration()
            if session.canSetSessionPreset(.hd1280x720) {
                session.sessionPreset = .hd1280x720
            }
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            session.commitConfiguration()
            
            let previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            anchroLayer.frame = view.bounds
            view.layer.addSublayer(anchroLayer)
            
            faceHandler.anchor = anchroLayer
        } catch {
            print("There are no availd device input: \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !session.isRunning && !stopped {
            session.startRunning()
        }
    }
}

// 处理人脸数据
extension CameraViewController {
    private func handleSampleBuffer(_ buffer: CMSampleBuffer) {
        guard let cvImageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return
        }
        let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
        
        faceHandler.handleImage(ciImage)
        
//        let context = CIContext()
//        guard let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
//            return
//        }
//        let faces = detector.features(in: ciImage)
//        if faces.count > 0 {
//            print("====识别到人脸\(faces.count)")
//            session.stopRunning()
//        }
//        for face in faces {
//            let faceFeature = face as! CIFaceFeature
//            anchroLayer.updateAnchor(faceFeature)
//        }
    }
}


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Called whenever an AVCaptureVideoDataOutput instance outputs a new video frame.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        handleSampleBuffer(sampleBuffer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
