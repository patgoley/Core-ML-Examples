//
//  Classifier.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/27/21.
//

import UIKit
import Vision
import Combine

struct Classification {
    
    let label: String
    let confidence: Float
}

enum ClassificationError: Error {
    
    case invalidImage, modelError(Error)
}

struct Classifier {
    
    private static var model: VNCoreMLModel! = nil
    
    static func setup() throws {
        
        let config = MLModelConfiguration()
        config.computeUnits = .all
        
        model = try VNCoreMLModel(
            for: KaggleCatsDogsClassifier(configuration: config).model
        )
    }
    
    static func classify(_ image: UIImage) -> AnyPublisher<[Classification], ClassificationError> {
        
        guard let ciImage = CIImage(image: image) else {
            return Future.fail(with: .invalidImage)
                .eraseToAnyPublisher()
        }
        
        return Future<CIImage, Never>.succeed(with: ciImage)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap { ciImage in
                requestClassifications(image: ciImage, orientation: .init(imageOrientation:  image.imageOrientation))
            }
            .eraseToAnyPublisher()
    }
    
    private static func requestClassifications(image: CIImage, orientation: CGImagePropertyOrientation) -> Future<[Classification], ClassificationError> {
        
        return Future { promise in
            
            let request = VNCoreMLRequest(model: model) { (req, error) in
            
                if let err = error {
                    
                    promise(.failure(.modelError(err)))
                    return
                }
                
                let results = req.results as! [VNClassificationObservation]
                
                promise(.success(results.map { r in Classification(label: r.identifier, confidence: r.confidence) }))
            }
            
            let handler = VNImageRequestHandler(ciImage: image, orientation: orientation)
            
            do {
                
                try handler.perform([request])
                
            } catch let err {
                
                promise(.failure(.modelError(err)))
            }
        }
    }
    
    private init() { }
}

extension CGImagePropertyOrientation {
    
    init(imageOrientation: UIImage.Orientation) {
        switch imageOrientation {
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .up:
            self = .up
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        case .upMirrored:
            self = .upMirrored
        @unknown default:
            self = .up
        }
    }
}
