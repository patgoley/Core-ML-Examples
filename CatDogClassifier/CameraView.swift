//
//  CameraView.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    let camera: Camera
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        return CameraViewController(camera: camera)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
