//
//  HomePokemonGridCell.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

class HomePokemonGridCell: HomePokemonCell {
    static var cellID: String = "HomePokemonGridCell"
    
    var ivSprite: UIImageView!
    var lbId: UILabel!
    var lbName: UILabel!
    var lbTypes: UILabel!
    var btnFavorite: UIButton!
    var imageLoader = DownloadImageViewModel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        let ivSprite = UIFactory.createImage(name: "")
        let lbId = UIFactory.createLabel(size: 12*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let lbName = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        let lbTypes = UIFactory.createLabel(size: 12*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let btnFavorite = UIFactory.createImageButton(name: "", tintColor: ColorFactory.heartRed)
        
        self.ivSprite = ivSprite
        self.lbId = lbId
        self.lbName = lbName
        self.lbTypes = lbTypes
        self.btnFavorite = btnFavorite
        
        contentView.addSubview(ivSprite)
        contentView.addSubview(lbId)
        contentView.addSubview(lbName)
        contentView.addSubview(lbTypes)
        contentView.addSubview(btnFavorite)
        
        ivSprite.contentMode = .scaleAspectFit
        lbId.textAlignment = .center
        lbName.textAlignment = .center
        lbTypes.textAlignment = .center
        
        btnFavorite.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        
        let margin = 10*scale
        let itemInset = 5*scale
        
        ivSprite.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(margin)
            make.width.equalTo(contentView.snp.width).offset(-2*margin)
            make.height.equalTo(contentView.snp.width).offset(-2*margin)
        }
        
        lbId.snp.makeConstraints { make in
            make.top.equalTo(ivSprite.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(15*scale)
        }
        
        lbName.snp.makeConstraints { make in
            make.top.equalTo(lbId.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(17*scale)
        }
        
        lbTypes.snp.makeConstraints { make in
            make.top.equalTo(lbName.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(15*scale)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.top.equalTo(lbTypes.snp.bottom).offset(itemInset)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(26*scale)
            make.height.equalTo(26*scale)
        }
    }
    
    override func setupWithItem(item: HomePokemonListModel) {
        self.item = item
        
        lbName?.text = item.name.capitalized
        lbId?.text = item.idStr
        lbTypes?.text = item.types.map { $0.capitalized }.joined(separator: ", ")
        
        ivSprite?.image = nil
        if let ivSprite = self.ivSprite, !item.imageUrlStr.isEmpty {
            imageLoader.downloadImage(iv: ivSprite, urlStr: item.imageUrlStr)
        } else {
            print()
        }
        
        updateFavoriteUI()
    }
    
    func updateFavoriteUI() {
        guard let item = self.item else {
            return
        }
        btnFavorite?.setBackgroundImage(UIFactory.getImage(named: item.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc func btnFavoriteTapped() {
        print(#function)
        guard var item = self.item else {
            return
        }
        let isFavorite = !item.isFavorite
        item.isFavorite = isFavorite
        RealmManager.updatePokemonFavorite(pokemonID: item.id, isFavorite: isFavorite)
        self.item = item
        updateFavoriteUI()
        self.delegate?.homePokemonCellFavoriteUpdated()
    }
}
