//
//  PokemonLoader.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

struct PokemonLoader: GenericSingleDataLoaderProtocol {
    typealias Params = FileParams_pokemon
    typealias ResultType = PokemonResponseModel
    
    func loadDataFromCache(params: Params) throws -> Result<ResultType, Error> {
        guard let resultParams = try loadCacheFile(params: params) else {
            return .failure(CacheError.cacheError)
        }
        guard let data = resultParams.data else {
            return .failure(CacheError.cacheError)
        }
        guard let model = try parse(params: DataParseParams_pokemon(data: data)) else {
            return .failure(ParseError.parseError)
        }
        return .success(model)
    }
    
    func loadDataLocal(params: Params) throws -> Result<ResultType, Error> {
        guard let resultParams = try loadLocalFile(params: params) else {
            return .failure(LoadLocalError.loadError)
        }
        guard let data = resultParams.data else {
            return .failure(LoadLocalError.loadError)
        }
        guard let model = try parse(params: DataParseParams_pokemon(data: data)) else {
            return .failure(ParseError.parseError)
        }
        return .success(model)
    }
    
    func loadDataOnline(params: Params) async throws -> Result<ResultType, Error> {
        guard let resultParams = try await loadOnlineFile(params: params) else {
            return .failure(FetchError.fetchError)
        }
        guard let data = resultParams.data else {
            return .failure(LoadError.loadError)
        }
        guard let model = try parse(params: DataParseParams_pokemon(data: data)) else {
            return .failure(ParseError.parseError)
        }
        let cacheSuccess = saveCacheFile(params: resultParams)
        if !cacheSuccess {
            print("Error cache onlind file")
        }
        return .success(model)
    }
    
    private func loadCacheFile(params: Params) throws -> Params? {
        var resultParams = params
        let key = params.cacheKey
        
        if let data = JsonHelper().fetchJsonData(forKey: key) {
            resultParams.data = data
            return resultParams
        } else {
            return nil
        }
    }
    
    private func saveCacheFile(params: Params) -> Bool {
        guard let data = params.data else {
            return false
        }
        let key = params.cacheKey
        
        let saveInLocalResult = JsonHelper().storeJsonData(jsonData: data, forKey: key)
        return saveInLocalResult
    }
    
    private func loadLocalFile(params: Params) throws -> Params? {
        /*
        var resultParams = params
        
        if let path = Bundle.main.path(forResource: fileName, ofType: fileExt) {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                resultParams.data = data
                return resultParams
            }
        }
        */
        
        return nil
    }
    
    private func loadOnlineFile(params: Params) async throws -> Params? {
        let loader = LoadFileStrategy_pokemon()
        let result = try await loader.loadSingleFile(params: params)
        switch result {
        case .success(let resultParams):
            return resultParams
        case .failure(_):
            return nil
        }
    }
    
    private func parse(params: DataParseParams) throws -> PokemonResponseModel? {
        switch params {
        case let params as DataParseParams_pokemon:
            let parser = ParseStrategy_pokemon()
            guard let responseModel = parser.parseParams(params: params) else {
                throw ParseError.parseError
            }
            return responseModel
        default:
            throw ParseError.parseError
        }
    }
}

extension PokemonLoader {
    func mockCacheLocalData(params: Params) -> Bool {
        do {
            if let resultParams = try loadLocalFile(params: params) {
                if saveCacheFile(params: resultParams) {
                    return true
                }
            }
            return false
        } catch {
            return false
        }
    }
    
    func mockCacheOnlineData(params: Params, completion: @escaping (Bool)->Void) {
        Task {
            do {
                if let resultParams = try await loadOnlineFile(params: params) {
                    if saveCacheFile(params: resultParams) {
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
