//
//  DetailFlavorView.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit
import SnapKit

class DetailFlavorView: UIView {
    let scale: CGFloat = UIFactory.getScale()
    var item: PokemonSpeciesModel!
    
    var lbTitle: UILabel!
    var lbFlavor: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let lbTitle = UIFactory.createLabel(size: 18*scale, text: "Flavor".localized(), color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        let lbFlavor = UIFactory.createLabel(size: 16*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        
        self.lbTitle = lbTitle
        self.lbFlavor = lbFlavor
        
        addSubview(lbTitle)
        addSubview(lbFlavor)
        
        lbTitle.textAlignment = .center
        lbTitle.alpha = 0
        
        lbFlavor.numberOfLines = 0
        lbFlavor.textAlignment = .center
        lbFlavor.alpha = 0
        
        let margin = 20*scale
        let itemInset = 5*scale
        
        lbTitle.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(margin)
            make.leading.equalTo(snp.leading).offset(margin)
            make.trailing.equalTo(snp.trailing).offset(-margin)
        }
        
        lbFlavor.snp.makeConstraints { make in
            make.top.equalTo(lbTitle.snp.bottom).offset(itemInset)
            make.leading.equalTo(snp.leading).offset(margin)
            make.trailing.equalTo(snp.trailing).offset(-margin)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(lbFlavor.snp.bottom).offset(margin)
        }
    }
    
    func setupContent(item: PokemonSpeciesModel) {
        self.item = item
        guard let flavor_text_entries = item.flavor_text_entries else {
            return
        }
        
        let language = LanguageManager.shared.getPokemonLanuageEnum().rawValue
        var flavorTextList = [String]()
        for flavor_text_entrie in flavor_text_entries {
            if let name = flavor_text_entrie.language?.name, name == language,
               let flavor_text = flavor_text_entrie.flavor_text, !flavor_text.isEmpty
            {
//                flavorTextList.append(flavor_text.replacingOccurrences(of: "\n", with: ""))
                flavorTextList.append(flavor_text)
                break
            }
        }
        
        if !flavorTextList.isEmpty {
            lbFlavor?.text = flavorTextList[0]
            if let lbTitle = lbTitle, let lbFlavor = lbFlavor {
                AnimationFactory.fadeIn(lbTitle)
                AnimationFactory.fadeIn(lbFlavor)
            }
        }
    }
}
