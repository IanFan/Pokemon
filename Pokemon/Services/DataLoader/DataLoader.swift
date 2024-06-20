//
//  DataLoader.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

class GenericSingleDataLoader<T: GenericSingleDataLoaderProtocol> {
    typealias Params = T.Params
    typealias ResultType = T.ResultType
    
    private var dataLoader: T
    
    init(dataLoader: T) {
        self.dataLoader = dataLoader
    }
    
    func loadData(params: Params, completion: @escaping (Result<ResultType, Error>)->Void) {
        Task {
            do {
                let result = try await loadData(params: params)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(LoadError.loadError))
                }
            }
        }
    }
    
    func loadData(params: Params) async throws -> Result<ResultType, Error> {
        // load from Cache
        switch try dataLoader.loadDataFromCache(params: params) {
        case .success(let cacheData):
//            print("\(#function) Cache params:\(params.self)")
            return .success(cacheData)
        case .failure(let error):
//            print("\(#function) Cache error: \(error)")
            break
        }
        
        // load from Local
        switch try dataLoader.loadDataLocal(params: params) {
        case .success(let localData):
//            print("\(#function) LocalData params:\(params.self)")
            return .success(localData)
        case .failure(let error):
//            print("\(#function) LocalData error: \(error)")
            break
        }
        
        // load from Online
        switch try await dataLoader.loadDataOnline(params: params) {
        case .success(let localData):
//            print("\(#function) OnlineData params:\(params.self)")
            return .success(localData)
        case .failure(let error):
//            print("\(#function) OnlineData error: \(error)")
            return .failure(error)
        }
    }
    
    func loadCacheOrLocalData(params: Params) throws -> Result<ResultType, Error> {
        // load from Cache
        switch try dataLoader.loadDataFromCache(params: params) {
        case .success(let cacheData):
//            print("\(#function) Cache params:\(params.self)")
            return .success(cacheData)
        case .failure(let error):
//            print("\(#function) Cache error: \(error)")
            break
        }
        
        // load from Local
        switch try dataLoader.loadDataLocal(params: params) {
        case .success(let localData):
//            print("\(#function) LocalData params:\(params.self)")
            return .success(localData)
        case .failure(let error):
//            print("\(#function) LocalData error: \(error)")
            return .failure(error)
        }
    }
}
