//
//  OptionalExtensions.swift
//  CatDogClassifier
//
//  Created by Patrick Goley on 1/29/21.
//

extension Optional {
    
    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .some(let x):
            return x
        case .none:
            throw error()
        }
    }
}
