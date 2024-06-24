//
//  DetailEvolutionView.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit
import SnapKit

protocol DetailEvolutionViewProtocol: AnyObject {
    func detailEvolutionViewTapped(pokemonSpecies: PokemonSpecies)
}

class DetailEvolutionView: UIStackView {
    let scale: CGFloat = UIFactory.getScale()
    weak var delegate: DetailEvolutionViewProtocol?
    var itemsList: [[PokemonSpecies]]!
    
    var evolotionViews = [EvolutionView]()
    var lbTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.alpha = 0
    }
    
    func setupContent(itemsList: [[PokemonSpecies]]) {
        guard !itemsList.isEmpty, evolotionViews.isEmpty else {
            return
        }
        self.itemsList = itemsList
        
        let margin = 20*scale
        let itemInset = 10*scale
        
        let lbTitle = UIFactory.createLabel(size: 18*scale, text: "Evolution Chain".localized(), color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        addSubview(lbTitle)
        lbTitle.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(itemInset)
            make.leading.equalTo(snp.leading).offset(margin)
            make.trailing.equalTo(snp.trailing).offset(-margin)
        }
        lbTitle.textAlignment = .center
        self.addArrangedSubview(lbTitle)
        
        for i in 0..<itemsList.count {
            let items = itemsList[i]
            for j in 0..<items.count {
                let item = items[j]
                let v = EvolutionView()
                v.translatesAutoresizingMaskIntoConstraints = false
                v.setupContent(item: item)
                v.delegate = self
                evolotionViews.append(v)
                self.addArrangedSubview(v)
            }
            
            if i != itemsList.count-1 {
                let ivArrow = UIFactory.createImage(name: "arrow.down", tintColor: ColorFactory.greyishBrown)
                ivArrow.contentMode = .scaleAspectFit
                addSubview(ivArrow)
                ivArrow.snp.makeConstraints { make in
                    make.centerX.equalTo(snp.centerX)
                    make.width.equalTo(20*scale)
                    make.height.equalTo(20*scale)
                }
                self.addArrangedSubview(ivArrow)
            }
        }
        
        AnimationFactory.fadeIn(self)
    }
}

extension DetailEvolutionView: EvolutionViewProtocol {
    func btnEvolutionTapped(item: PokemonSpecies) {
        self.delegate?.detailEvolutionViewTapped(pokemonSpecies: item)
    }
}


protocol EvolutionViewProtocol: AnyObject {
    func btnEvolutionTapped(item: PokemonSpecies)
}

class EvolutionView: UIView {
    let scale: CGFloat = UIFactory.getScale()
    weak var delegate: EvolutionViewProtocol?
    var item: PokemonSpecies!
    
    var btnEvolution: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let btnEvolution = UIFactory.createTextButton(size: 16*scale, text: "", textColor: ColorFactory.white2, bgColor: ColorFactory.greyishBrown, font: .PingFangTCRegular, corner: 15*scale)
        
        self.btnEvolution = btnEvolution
        
        addSubview(btnEvolution)
        
        btnEvolution.addTarget(self, action: #selector(btnEvolutionTapped), for: .touchUpInside)
        
        let margin = 10*scale
//        let itemInset = 10*scale
        
        self.snp.makeConstraints { make in
            make.height.equalTo(btnEvolution.snp.height).offset(2*margin)
        }
        
        btnEvolution.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(200*scale)
            make.height.equalTo(44*scale)
        }
    }
    
    func setupContent(item: PokemonSpecies) {
        self.item = item
        
        let name = item.name?.capitalized
        btnEvolution?.setTitle(name, for: .normal)
    }
    
    @objc func btnEvolutionTapped() {
        guard let item = item else {return}
        self.delegate?.btnEvolutionTapped(item: item)
    }
}
