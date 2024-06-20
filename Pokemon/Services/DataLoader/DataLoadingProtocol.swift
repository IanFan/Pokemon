//
//  DataLoadingProtocol.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

protocol GenericSingleDataLoaderProtocol {
    associatedtype Params
    associatedtype ResultType
    
    func loadDataFromCache(params: Params) throws -> Result<ResultType, Error>
    func loadDataLocal(params: Params) throws -> Result<ResultType, Error>
    func loadDataOnline(params: Params) async throws -> Result<ResultType, Error>
}
