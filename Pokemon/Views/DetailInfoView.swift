//
//  DetailInfoView.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit
import SnapKit

class DetailInfoView: UIView {
    let scale: CGFloat = UIFactory.getScale()
    var item: HomePokemonListModel!
    
    var ivSprite: UIImageView!
    var btnFavorite: UIButton!
    var lbId: UILabel!
    var lbName: UILabel!
    var lbTypes: UILabel!
    var imageLoader = DownloadImageViewModel()
    
    var btnFavoriteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.alpha = 0
        
        let ivSprite = UIFactory.createImage(name: "")
        let lbId = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let lbName = UIFactory.createLabel(size: 18*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        let lbTypes = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let btnFavorite = UIFactory.createImageButton(name: "", tintColor: ColorFactory.heartRed)
        
        self.ivSprite = ivSprite
        self.lbId = lbId
        self.lbName = lbName
        self.lbTypes = lbTypes
        self.btnFavorite = btnFavorite
        
        addSubview(ivSprite)
        addSubview(lbId)
        addSubview(lbName)
        addSubview(lbTypes)
        addSubview(btnFavorite)
        
        ivSprite.contentMode = .scaleAspectFit
        btnFavorite.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        
        let margin = 20*scale
        let itemInset = 15*scale
        
        ivSprite.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(margin)
            make.width.equalTo(90*scale)
            make.height.equalTo(90*scale)
        }
        
        lbId.snp.makeConstraints { make in
            make.bottom.equalTo(lbName.snp.top).offset(-4*scale)
            make.leading.equalTo(snp.leading).offset(90*scale+itemInset+margin)
            make.trailing.equalTo(snp.trailing).offset(-44*scale-itemInset-margin)
            make.height.equalTo(20*scale)
        }
        
        lbName.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
            make.height.equalTo(20*scale)
        }
        
        lbTypes.snp.makeConstraints { make in
            make.top.equalTo(lbName.snp.bottom).offset(4*scale)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
            make.height.equalTo(20*scale)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-margin)
            make.width.equalTo(36*scale)
            make.height.equalTo(36*scale)
        }
    }
    
    func setupContent(item: HomePokemonListModel) {
        self.item = item
        
        lbName?.text = item.name.capitalized
        lbId?.text = item.idStr
        lbTypes?.text = item.types.map{ $0.capitalized }.joined(separator: ", ")
        
        ivSprite?.image = nil
        if let ivSprite = self.ivSprite, !item.imageUrlStr.isEmpty {
            imageLoader.downloadImage(iv: ivSprite, urlStr: item.imageUrlStr)
        }
        
        updateFavoriteUI()
        
        AnimationFactory.fadeIn(self)
    }
    
    func updateFavoriteUI() {
        guard let item = self.item, let realmObj = RealmManager.getPokemon(byID: item.id) else {
            return
        }
        btnFavorite?.setBackgroundImage(UIFactory.getImage(named: realmObj.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc private func btnFavoriteTapped() {
        let isFavorite = !item.isFavorite
        item.isFavorite = isFavorite
        RealmManager.updatePokemonFavorite(pokemonID: item.id, isFavorite: isFavorite)
        btnFavoriteAction?()
    }
}
