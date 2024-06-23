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
    
    var lbFlavor: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let lbFlavor = UIFactory.createLabel(size: 16*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        
        self.lbFlavor = lbFlavor
        
        addSubview(lbFlavor)
        
        lbFlavor.numberOfLines = 0
        
        let margin = 20*scale
        let itemInset = 15*scale
        
        self.snp.makeConstraints { make in
            make.height.equalTo(lbFlavor.snp.height).offset(2*margin)
        }
        
        lbFlavor.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(margin)
            make.leading.equalTo(snp.leading).offset(margin)
            make.trailing.equalTo(snp.trailing).offset(-margin)
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
                flavorTextList.append(flavor_text.replacingOccurrences(of: "\n", with: ""))
                break
            }
        }
        
        if !flavorTextList.isEmpty {
            lbFlavor?.text = flavorTextList[0]
        }
        
        self.layoutIfNeeded()
    }
}
