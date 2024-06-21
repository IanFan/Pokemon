//
//  PokemonTypeListViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

protocol PokemonTypeViewModelProtocol: AnyObject {
    func updatePokemonTypeUI()
}

class PokemonTypeViewModel: NSObject {
    weak var delegate: PokemonTypeViewModelProtocol?
    var pokemonTypeList = [PokemonTypeListModel]()
    var pokemonTypeDetailDic = [String: PokemonTypeDetailModel]() // [typeName: deailModel]
    var pokemonNameTypeDic = [String: String]() // [pokemonNmae: typeName]
    var pokemonIdTypeDic = [String: String]() // [pokemonId: typeName]
    var page = 0
    var isRequesting: Bool = false
    
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    
    func loadData(isRefresh: Bool = false) {
        let startTime = Date()
        
        loadListData(isRefresh: isRefresh, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listObjs):
                self.pokemonTypeList.append(contentsOf: listObjs)
                loadDetailData(isRefresh: isRefresh, pokemonTypeList: listObjs, completion: { detailResult in
                    switch detailResult {
                    case .success(let detailDic):
                        DispatchQueue.main.async {
                            let (nameTypeDic, idTypeDic) = self.mapToPokemonTypeDic(dic: detailDic)
                            self.pokemonNameTypeDic = nameTypeDic
                            self.pokemonIdTypeDic = idTypeDic
                            self.pokemonTypeDetailDic = detailDic
                            self.delegate?.updatePokemonTypeUI()
                            self.successAction?()
                            
                            let endTime = Date()
                            let timeInterval = endTime.timeIntervalSince(startTime)
                            print("loadPokemonTypeData cost time: \(timeInterval)")
                        }
                    case .failure(let error):
                        print("load error: \(error)")
                        DispatchQueue.main.async {
                            self.failAction?()
                        }
                    }
                })
            case .failure(let error):
                print("load error: \(error)")
                DispatchQueue.main.async {
                    self.failAction?()
                }
            }
            
            self.delegate?.updatePokemonTypeUI()
        })
    }
    
    private func loadListData(isRefresh: Bool = false, completion: @escaping (Result<[PokemonTypeListModel], Error>) -> Void) {
        
        guard !isRequesting else {
            return
        }
        
        if isRefresh {
            page = 0
        }
        
        self.isRequesting = true
        let params = FileParams_pokemonTypeList(page: page)
        let loader = GenericSingleDataLoader(dataLoader: PokemonTypeListLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .success(let resultParams):
                guard let objs = resultParams.results else {
                    DispatchQueue.main.async {
                        completion(.failure(LoadError.emptyDataError))
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.page += 1
                    completion(.success(objs))
                }
            case .failure(let error):
                print("load error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(LoadError.loadError))
                }
            }
        })
    }
    
    private func loadDetailData(isRefresh: Bool = false, pokemonTypeList: [PokemonTypeListModel],  completion: @escaping (Result<[String: PokemonTypeDetailModel], Error>) -> Void) {
        
        guard !isRequesting else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var loadError: Error?
        
        var tmpDic = [String: PokemonTypeDetailModel]()
        self.isRequesting = true
        for pokemonType in pokemonTypeList {
            dispatchGroup.enter()
            loadSingleDetailData(isRefresh: isRefresh, pokemonTypeList: pokemonType, completion: { result in
                switch result {
                case .success(let (name, model)):
                    tmpDic[name] = model
                case .failure(let error):
                    loadError = error
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isRequesting = false
            if let error = loadError {
                completion(.failure(error))
            } else {
                completion(.success(tmpDic))
            }
        }
    }
    
    private func loadSingleDetailData(isRefresh: Bool = false, pokemonTypeList: PokemonTypeListModel,  completion: @escaping (Result<(String, PokemonTypeDetailModel), Error>) -> Void) {
        let name = pokemonTypeList.name
        let id = pokemonTypeList.id
        let params = FileParams_pokemonTypeDetail(name: name, id: id)
        let loader = GenericSingleDataLoader(dataLoader: PokemonTypeDetailLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                let obj = resultParams
                DispatchQueue.main.async {
                    completion(.success((name, obj)))
                }
            case .failure(let error):
                print("load error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(LoadError.loadError))
                }
            }
        })
    }
    
    
    private func mapToPokemonTypeDic(dic: [String: PokemonTypeDetailModel]) -> ([String: String], [String: String]) {
        let startTime = Date()
        
        var nameTypeDic = [String: String]()
        var idTypeDic = [String: String]()
        for (typeName, model) in dic {
            if let pokemon = model.pokemon {
                for pokemonSlot in pokemon {
                    if let poke = pokemonSlot.pokemon, let pokeName = poke.name, let url = poke.url {
                        nameTypeDic[pokeName] = typeName
                        if let idString = url.split(separator: "/").last  {
                            idTypeDic[String(idString)] = typeName
                        }
                    }
                }
            }
        }
        
        let endTime = Date()
        let timeInterval = endTime.timeIntervalSince(startTime)
        print("mapToPokemonTypeDic cost time: \(timeInterval)")
        
        return (nameTypeDic, idTypeDic)
    }
}
