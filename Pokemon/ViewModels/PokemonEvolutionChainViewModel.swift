//
//  PokemonEvolutionChainViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit

protocol PokemonEvolutionChainViewModelProtocol: AnyObject {
    func updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: PokemonEvolutionChainModel, speciesList: [[PokemonSpecies]])
}

class PokemonEvolutionChainViewModel: NSObject {
    weak var delegate: PokemonEvolutionChainViewModelProtocol?
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    var pokemonEvolutionChainModel: PokemonEvolutionChainModel?
    var speciesList = [[PokemonSpecies]]()
    
    func loadData(isRefresh: Bool = false, id: Int) {
        loadData(isRefresh: isRefresh, id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                DispatchQueue.main.async {
                    let (obj, specesList) = resultParams
                    self.delegate?.updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: obj, speciesList: specesList)
                }
            case .failure(let error):
                break
            }
        })
    }
    
    private func loadData(isRefresh: Bool = false, id: Int, completion: @escaping (Result<(PokemonEvolutionChainModel, [[PokemonSpecies]]), Error>) -> Void) {
        
        let params = FileParams_pokemonEvolutionChain(id: id)
        let loader = GenericSingleDataLoader(dataLoader: PokemonEvolutionChainLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                let obj = resultParams
                DispatchQueue.main.async {
                    self.pokemonEvolutionChainModel = obj
                    let specesList = self.getChainSpeciesList(model: obj)
                    self.speciesList = specesList
                    completion(.success((obj, specesList)))
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
    
    private func getChainSpeciesList(model: PokemonEvolutionChainModel) -> [[PokemonSpecies]] {
        var ans = [[PokemonSpecies]]()
        var chains = [PokemonChainLink]()
        if let chain = model.chain {
            chains.append(chain)
        }
        while !chains.isEmpty {
            var tmpChains = [PokemonChainLink]()
            var tmpSpecies = [PokemonSpecies]()
            for chain in chains {
                if let species = chain.species, let name = species.name, let url = species.url {
                    if let evolves_to = chain.evolves_to, !evolves_to.isEmpty {
                        tmpChains.append(contentsOf: evolves_to)
                    }
                    tmpSpecies.append(species)
                }
            }
            ans.append(tmpSpecies)
            chains = tmpChains
        }
        return ans
    }
}
