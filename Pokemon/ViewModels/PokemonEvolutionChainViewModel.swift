//
//  PokemonEvolutionChainViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit

protocol PokemonEvolutionChainViewModelProtocol: AnyObject {
    func updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: PokemonEvolutionChainModel)
}

class PokemonEvolutionChainViewModel: NSObject {
    weak var delegate: PokemonEvolutionChainViewModelProtocol?
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    var pokemonEvolutionChainModel: PokemonEvolutionChainModel?
    
    func loadData(isRefresh: Bool = false, id: Int) {
        loadData(isRefresh: isRefresh, id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                DispatchQueue.main.async {
                    let obj = resultParams
                    self.delegate?.updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: obj)
                }
            case .failure(let error):
                break
            }
        })
    }
    
    func loadData(isRefresh: Bool = false, id: Int, completion: @escaping (Result<PokemonEvolutionChainModel, Error>) -> Void) {
        
        let params = FileParams_pokemonEvolutionChain(id: id)
        let loader = GenericSingleDataLoader(dataLoader: PokemonEvolutionChainLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                let obj = resultParams
                DispatchQueue.main.async {
                    self.pokemonEvolutionChainModel = obj
                    completion(.success(obj))
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
}
