//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

protocol PokemonDetailViewModelProtocol: AnyObject {
    func updatePokemonDetailUI()
}

class PokemonDetailViewModel: NSObject {
    weak var delegate: PokemonDetailViewModelProtocol?
    var pokemonDetailModel: PokemonDetailModel?
    
    var successAction: (() -> Void)?
    var failAction: (() -> Void)?
    
    func loadData(isRefresh: Bool = false, name: String, id: Int) {
        loadData(isRefresh: isRefresh, name: name, id: id, completion: { result in
            self.delegate?.updatePokemonDetailUI()
        })
    }
    
    func loadData(isRefresh: Bool = false, name: String, id: Int, completion: @escaping (Result<PokemonDetailModel, Error>) -> Void) {
        
        let params = FileParams_pokemonDetail(name: name, id: id)
        let loader = GenericSingleDataLoader(dataLoader: PokemonDetailLoader())
        loader.loadData(params: params, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultParams):
                let obj = resultParams
                DispatchQueue.main.async {
                    self.pokemonDetailModel = obj
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
