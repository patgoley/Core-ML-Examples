//
//  Camera.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import Foundation
import AVFoundation
import Combine

enum CameraError: Error {
    
    case noDeviceFound, setupFailed
}

final class Camera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    let session: AVCaptureSession
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    private let bufferSubject: PassthroughSubject<CMSampleBuffer, Never> = .init()
    
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
        
        if session.canAddOutput(output) {
            
            output.alwaysDiscardsLateVideoFrames = true
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            
            session.addOutput(output)
        } else {
            
            throw CameraError.setupFailed
        }
        
        self.session.commitConfiguration()
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        
        return AVCaptureVideoPreviewLayer(session: session)
    }
    
    func getBufferStream() -> AnyPublisher<CMSampleBuffer, Never> {
        
        return bufferSubject.eraseToAnyPublisher()
    }
    
    func startFeed() {
        
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        bufferSubject.send(sampleBuffer)
    }
}
