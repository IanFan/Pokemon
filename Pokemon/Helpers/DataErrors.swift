//
//  DataErrors.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

enum LoadError: Error {
    case loadError
    case paramError
    case isLastDataError
    case emptyDataError
    case customError(String)
}

enum FetchError: Error {
    case fetchError
    case customError(String)
}

enum CacheError: Error {
    case cacheError
    case customError(String)
}

enum ParseError: Error {
    case parseError
    case invalidData
    case customError(String)
}

enum LoadLocalError: Error {
    case loadError
    case jsonError
    case parseError
    case customError(String)
    case passError
}

enum GenerateError: Error {
    case generateError
}

enum ImageError: Error {
    case imageError
}
