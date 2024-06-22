//
//  ImageLoader.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

struct ImageLoader: GenericSingleDataLoaderProtocol {
    typealias Params = FileParams_file
    typealias ResultType = UIImage
    
    func loadDataFromCache(params: Params) throws -> Result<ResultType, Error> {
        guard let resultParams = try loadCacheFile(params: params) else {
            return .failure(CacheError.cacheError)
        }
        guard let data = resultParams.data else {
            return .failure(CacheError.cacheError)
        }
        guard let image = UIImage(data: data) else {
            return .failure(ImageError.imageError)
        }
        return .success(image)
    }
    
    func loadDataLocal(params: Params) throws -> Result<ResultType, Error> {
        guard let resultParams = try loadLocalFile(params: params) else {
            return .failure(LoadLocalError.loadError)
        }
        guard let data = resultParams.data else {
            return .failure(LoadLocalError.loadError)
        }
        guard let image = UIImage(data: data) else {
            return .failure(ImageError.imageError)
        }
        return .success(image)
    }
    
    func loadDataOnline(params: Params) async throws -> Result<ResultType, Error> {
        guard let resultParams = try await loadOnlineFile(params: params) else {
            return .failure(FetchError.fetchError)
        }
        guard let data = resultParams.data else {
            return .failure(LoadError.loadError)
        }
        guard let image = UIImage(data: data) else {
            return .failure(ImageError.imageError)
        }
        let cacheSuccess = saveCacheFile(params: resultParams)
        if !cacheSuccess {
            print("Error cache onlind file")
        }
        return .success(image)
    }
    
    private func loadCacheFile(params: Params) throws -> Params? {
        var resultParams = params
        let key = params.cacheKey
        
        guard let data = FileHelper.loadDataFromDisk(forKey: key) else {
            return nil
        }
        resultParams.data = data
        return resultParams
    }
    
    private func saveCacheFile(params: Params) -> Bool {
        guard let data = params.data else {
            return false
        }
        let key = params.cacheKey
        
        let saveInLocalResult = FileHelper.saveDataToDisk(data, forKey: key)
        return saveInLocalResult
    }
    
    private func loadLocalFile(params: Params) throws -> Params? {
        return nil
    }
    
    private func loadOnlineFile(params: Params) async throws -> Params? {
        let loader = LoadFileStrategy_file()
        let result = try await loader.loadSingleFile(params: params)
        switch result {
        case .success(let resultParams):
            return resultParams
        case .failure(_):
            return nil
        }
    }
}

extension ImageLoader {
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
