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

// MARK: - LOADER pokemonList

struct FileParams_pokemonList: FileParams {
    var api: String = "pokemon"
    var limit: Int = 20
    var page: Int
    var data: Data?
    
    var offset: Int {
        return limit*page
    }
    var cacheKey: String {
        return "PokemonList_\(api)_\(limit)_\(offset)"
    }
}

class LoadFileStrategy_pokemonList: LoadFileStrategy {
    typealias Params = FileParams_pokemonList
    typealias ResultType = FileParams_pokemonList
    
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

// MARK: - LOADER pokemonDetail

struct FileParams_pokemonDetail: FileParams {
    var api: String = "pokemon"
    var name: String
    var id: Int
    var data: Data?
    
    var cacheKey: String {
        return "PokemonDetail_\(api)_\(id)"
    }
}

class LoadFileStrategy_pokemonDetail: LoadFileStrategy {
    typealias Params = FileParams_pokemonDetail
    typealias ResultType = FileParams_pokemonDetail
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        let api = params.api
        let name = params.name
        
        return await withCheckedContinuation { continuation in
            let url = "\(RequestStruct.DOMAIN)/\(api)/\(name)"
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

// MARK: - LOADER pokemonSpecies

struct FileParams_pokemonSpecies: FileParams {
    var api: String = "pokemon-species"
    var name: String
    var id: Int
    var data: Data?
    
    var cacheKey: String {
        return "PokemonSpecies_\(api)_\(id)"
    }
}

class LoadFileStrategy_pokemonSpecies: LoadFileStrategy {
    typealias Params = FileParams_pokemonSpecies
    typealias ResultType = FileParams_pokemonSpecies
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        let api = params.api
        let name = params.name
        
        return await withCheckedContinuation { continuation in
            let url = "\(RequestStruct.DOMAIN)/\(api)/\(name)"
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

// MARK: - LOADER pokemonEvolutionChain

struct FileParams_pokemonEvolutionChain: FileParams {
    var api: String = "evolution-chain"
    var id: Int
    var data: Data?
    
    var cacheKey: String {
        return "PokemonSpecies_\(api)_\(id)"
    }
}

class LoadFileStrategy_pokemonEvolutionChain: LoadFileStrategy {
    typealias Params = FileParams_pokemonEvolutionChain
    typealias ResultType = FileParams_pokemonEvolutionChain
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        let api = params.api
        let id = params.id
        
        return await withCheckedContinuation { continuation in
            let url = "\(RequestStruct.DOMAIN)/\(api)/\(id)"
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

// MARK: - LOADER pokemonTypeList

struct FileParams_pokemonTypeList: FileParams {
    var api: String = "type"
    var limit: Int = 30
    var page: Int
    var data: Data?
    
    var offset: Int {
        return limit*page
    }
    var cacheKey: String {
        return "PokemonTypeList_\(api)_\(limit)_\(offset)"
    }
}

class LoadFileStrategy_pokemonTypeList: LoadFileStrategy {
    typealias Params = FileParams_pokemonTypeList
    typealias ResultType = FileParams_pokemonTypeList
    
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

// MARK: - LOADER pokemonTypeDetail

struct FileParams_pokemonTypeDetail: FileParams {
    var api: String = "type"
    var name: String
    var id: Int
    var data: Data?
    
    var cacheKey: String {
        return "PokemonTypeDetail_\(api)_\(id)"
    }
}

class LoadFileStrategy_pokemonTypeDetail: LoadFileStrategy {
    typealias Params = FileParams_pokemonTypeDetail
    typealias ResultType = FileParams_pokemonTypeDetail
    
    func loadSingleFile(params: Params) async throws -> Result<ResultType, Error> {
        let api = params.api
        let name = params.name
        
        return await withCheckedContinuation { continuation in
            let url = "\(RequestStruct.DOMAIN)/\(api)/\(name)"
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
