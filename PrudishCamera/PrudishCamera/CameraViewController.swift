//
//  CameraViewController.swift
//  PrudishCamera
//
//  Created by JinFeng on 2021/8/4.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    
    private let outputQueue = DispatchQueue.init(label: "output")
    
    private let session = AVCaptureSession()
    
    private var stopped = false
    
    private var currentMetadataObjects: [AVMetadataObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDevice()
    }
    
    
    private func setupDevice() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            let deviceInput = try AVCaptureDeviceInput.init(device: device)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: outputQueue)
            output.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA]
            
            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.setMetadataObjectsDelegate(self, queue: outputQueue)
            print(metadataOutput.availableMetadataObjectTypes)
            if metadataOutput.availableMetadataObjectTypes.contains(.face) {
                metadataOutput.metadataObjectTypes = [.face]
            }
            
            session .beginConfiguration()
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            if session.canSetSessionPreset(.hd1280x720) {
                session.sessionPreset = .hd1280x720
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
            }
            session.commitConfiguration()
            
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


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Called whenever an AVCaptureVideoDataOutput instance outputs a new video frame.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let objects = currentMetadataObjects else {
            return
        }
        for obj in objects {
            print(obj)
        }
    }
}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    // Called whenever an AVCaptureMetadataOutput instance emits new objects through a connection.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        currentMetadataObjects = metadataObjects
    }
}
