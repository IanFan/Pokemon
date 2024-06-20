//
//  LoadFileStrategy.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

protocol LoadFileStrategy {
    associatedtype Params
    associatedtype ResultType
     
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error>
}

protocol FileParams {
    var data: Data? {get set}
}

// MARK: - LOADER user

struct FileParams_pokemon: FileParams {
    var api: String
    var limit: Int = 20
    var page: Int
    var data: Data?
    
    var offset: Int {
        return limit*page
    }
    var cacheKey: String {
        return "\(api)_\(limit)_\(offset)"
    }
}

class LoadFileStrategy_pokemon: LoadFileStrategy {
    typealias Params = FileParams_pokemon
    typealias ResultType = FileParams_pokemon
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        let api = params.api
        let limit = params.limit
        let offset = params.offset
        
        return await withCheckedContinuation { continuation in
            let url = "\(RequestStruct.DOMAIN)/\(api)/?limit=\(limit)&offset=\(offset)"
            RequestManager.shared.httpGet(url: url, parameters: nil, httpClosure: { data, response, error in
                if let data = data {
                    var resultParams = params
                    resultParams.data = data
                    continuation.resume(returning: .success(resultParams))
                } else {
                    let error = NSError(domain: "RequestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request failed or no data"])
                    continuation.resume(returning: .failure(error))
                }
            })
        }
    }
}

// MARK: - LOADER file

struct FileParams_file: FileParams {
    var url: String
    var data: Data?
    
    var cacheKey: String {
        return "\(url)"
    }
}

class LoadFileStrategy_file: LoadFileStrategy {
    typealias Params = FileParams_file
    typealias ResultType = FileParams_file
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        guard let url = URL(string: params.url) else {
            return .failure(LoadError.paramError)
        }
        return await withCheckedContinuation { continuation in
            RequestManager.shared.downloadFile(from: url, completion: { data in
                if let data = data {
                    var resultParams = params
                    resultParams.data = data
                    continuation.resume(returning: .success(resultParams))
                } else {
                    let error = NSError(domain: "RequestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request failed or no data"])
                    continuation.resume(returning: .failure(error))
                }
            })
        }
    }
}
