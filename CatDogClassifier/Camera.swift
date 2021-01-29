//
//  Camera.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import Foundation
import AVFoundation

enum CameraError: Error {
    
    case noDeviceFound
}

final class Camera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    let session: AVCaptureSession
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    init(session: AVCaptureSession = .init()) throws {
        
        let device = try AVCaptureDevice.default(for: .video)
            .orThrow(CameraError.noDeviceFound)
        let input = try AVCaptureDeviceInput(device: device)
        
        if session.canAddInput(input) {
            
            session.addInput(input)
        } else {
            
            throw CameraError.noDeviceFound
        }
        
        self.session = session
        
        super.init()
        
        let output = AVCaptureVideoDataOutput()
        
        output.setSampleBufferDelegate(self, queue: queue)
        
        self.session.commitConfiguration()
    }
    
    func startFeed() {
        
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let image = sampleBuffer.imageBuffer
        
        print("got image")
    }
}

private class SampleBufferDelegateProxy: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let image = sampleBuffer.imageBuffer
        
        print("got image")
    }
}
