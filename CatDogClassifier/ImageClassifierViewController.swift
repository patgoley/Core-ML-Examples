//
//  ImageClassifierViewController.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import UIKit
import AVFoundation
import Combine

class ImageClassifierViewController: UIViewController {

    private let camera: Camera
    private let classifier: Classifier
    private let previewLayer: AVCaptureVideoPreviewLayer
    private var cameraCancellable: AnyCancellable? = nil
    private var classifierCancellable: AnyCancellable? = nil
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var labelsLabel: UILabel!
    
    init(camera: Camera, classifier: Classifier) {
        self.camera = camera
        self.classifier = classifier
        self.previewLayer = camera.getPreviewLayer()
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cameraView.layer.addSublayer(previewLayer)
        
        cameraCancellable = camera.getBufferStream()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.processImageBuffer($0) })
        
        camera.startFeed()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = cameraView.layer.bounds
    }
    
    func processImageBuffer(_ buffer: CMSampleBuffer) {
        
        guard classifierCancellable == nil else {
            return
        }
        
        classifierCancellable = classifier.classify(sampleBuffer: buffer)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (result) in
                switch result {
                case .failure(let err):
                    print("Error: \(err)")
                case .finished:
                    self?.classifierCancellable = nil
                }
            }, receiveValue: { [weak self] (labels) in
                self?.updateLabels(labels)
            })
    }
    
    func updateLabels(_ labels: [Classification]) {
        
        let items = labels
            .sorted()
            .reversed()
            .map(\.description)
            .joined(separator: "\n")
        
        labelsLabel.text = items
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
