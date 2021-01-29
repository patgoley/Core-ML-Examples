//
//  CombineExtensions.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/28/21.
//

import Combine

extension Future {
    
    static func fail(with error: Failure) -> Future<Output, Failure> {
        return Future { (promise) in
            promise(.failure(error))
        }
    }
    
    static func succeed(with value: Output) -> Future<Output, Failure> {
        return Future { (promise) in
            promise(.success(value))
        }
    }
}
