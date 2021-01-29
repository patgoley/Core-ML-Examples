//
//  AppDelegate.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/28/21.
//

import UIKit
import Combine

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var cancellables: Set<AnyCancellable> = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        try! Classifier.setup()
        
        testImage("cat-1")
        testImage("dog-1")
        
        return true
    }
    
    func testImage(_ name: String) {
        
        let image = UIImage(named: name)!
        
        Classifier.classify(image)
            .sink(receiveCompletion: { (error) in
                print(error)
            }, receiveValue: { (labels) in
                
                let desc = labels
                    .map { l in "\(l.label): \(l.confidence)" }
                    .joined(separator: ", ")
            
                print("Labels for \(name): \(desc)")
                
            }).store(in: &cancellables)
    }
}
