//
//  CameraViewController.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let previewLayer: AVCaptureVideoPreviewLayer
    let camera: Camera
    
    init(camera: Camera) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        self.camera = camera
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.layer.addSublayer(previewLayer)
        
        camera.startFeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.layer.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
