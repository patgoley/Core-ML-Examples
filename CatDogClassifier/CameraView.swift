//
//  CameraView.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import SwiftUI

struct ImageClassifierView: UIViewControllerRepresentable {
    
    let camera: Camera
    let classifier: Classifier
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        return ImageClassifierViewController(camera: camera, classifier: classifier)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
