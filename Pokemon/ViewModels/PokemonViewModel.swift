//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

protocol PokemonViewModelProtocol: AnyObject {
    func updatePokemonUI(complete: (Bool)->Void)
}

class PokemonViewModel: NSObject {
    weak var delegate: PokemonViewModelProtocol?
    var pokemons = [PokemonModel]()
    var loadMorePokemons = [PokemonModel]()
    var page: Int = 0
    var isRequesting: Bool = false
    
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    
    func loadData(isRefresh: Bool = false) {
        loadData(isRefresh: isRefresh, completion: { result in
            self.delegate?.updatePokemonUI(complete: { [weak self] (isCompleted: Bool)->Void in
                guard let self = self else { return }
                self.pokemons.append(contentsOf: loadMorePokemons)
                self.loadMorePokemons.removeAll()
            })
        })
    }
    
    func loadData(isRefresh: Bool = false, completion: @escaping (Result<[PokemonModel], Error>) -> Void) {
        
        guard !isRequesting else {
            return
        }
        
        if isRefresh {
            page = 0
        }
        
        let api: String = "pokemon"
        
        self.isRequesting = true
        let params = FileParams_pokemon(api: api, page: page)
        let loader = GenericSingleDataLoader(dataLoader: PokemonLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .success(let resultParams):
                guard let objs = resultParams.results else {
                    DispatchQueue.main.async {
                        completion(.failure(LoadError.emptyDataError))
                        self.failAction?()
                    }
                    return
                }
                let sortedObjs = self.sortPokemonObjs(objs: objs)
                DispatchQueue.main.async {
                    self.loadMorePokemons = sortedObjs
                    self.page += 1
                    completion(.success(sortedObjs))
                    self.successAction?()
                }
            case .failure(let error):
                print("load error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(LoadError.loadError))
                    self.failAction?()
                }
            }
        })
    }
    
    private func sortPokemonObjs(objs: [PokemonModel]) -> [PokemonModel] {
        var objs = objs
        objs.sort {
            ($0.id ?? 0) < ($1.id ?? 0)
        }
        return objs
    }
}
