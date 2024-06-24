//
//  PokemonSpeciesViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit

protocol PokemonSpeciesViewModelProtocol: AnyObject {
    func updatePokemonSpeciesUI(pokemonSpeciesModel: PokemonSpeciesModel)
}

class PokemonSpeciesViewModel: NSObject {
    weak var delegate: PokemonSpeciesViewModelProtocol?
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    var pokemonSpeciesModel: PokemonSpeciesModel?
    
    func loadData(isRefresh: Bool = false, id: Int, name: String) {
        loadData(isRefresh: isRefresh, name: name, id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                DispatchQueue.main.async {
                    let obj = resultParams
                    self.delegate?.updatePokemonSpeciesUI(pokemonSpeciesModel: obj)
                }
            case .failure(let error):
                break
            }
        })
    }
    
    func loadData(isRefresh: Bool = false, name: String, id: Int, completion: @escaping (Result<PokemonSpeciesModel, Error>) -> Void) {
        
        let params = FileParams_pokemonSpecies(name: name, id: id)
        let loader = GenericSingleDataLoader(dataLoader: PokemonSpeciesLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                let obj = resultParams
                DispatchQueue.main.async {
                    self.pokemonSpeciesModel = obj
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
    
    func getEvolutionChainId() -> Int? {
        guard let model = pokemonSpeciesModel, let evolutionChainId = model.evolution_chain?.id else {
            return nil
        }
        return evolutionChainId
    }
}
