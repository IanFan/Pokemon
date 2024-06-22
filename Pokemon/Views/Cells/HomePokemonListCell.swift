//
//  HomePokemonListCell.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

class HomePokemonCell: UICollectionViewCell, PokemonDetailViewModelProtocol {
    let scale: CGFloat = UIFactory.getScale()
    var item: HomePokemonListModel?
    let pokemonDetailViewModel = PokemonDetailViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokemonDetailViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithItem(item: HomePokemonListModel) {}
    
    func loadDetailData(item: HomePokemonListModel) {
        pokemonDetailViewModel.loadData(isRefresh: false, id: item.id, name: item.name)
    }
    
    func updatePokemonDetailUI(pokemonDetailModel: PokemonDetailModel) {
        guard let item = self.item,
              item.id == pokemonDetailModel.id,
              let realObj = RealmManager.getPokemon(byID: pokemonDetailModel.id)
        else {
            return
        }
        
        let newItem = HomePokemonListModel(id: realObj.pokemonID, name: realObj.name, imageUrlStr: realObj.spriteFrontUrl, types: Array(realObj.types), isFavorite: realObj.isFavorite)
        setupWithItem(item: newItem)
    }
}

class HomePokemonListCell: HomePokemonCell {
    static var cellID: String = "HomePokemonListCell"
    
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
        pokemonDetailViewModel.delegate = self
    }
    
    func setupUI() {
//        contentView.backgroundColor = ColorFactory.white2
        contentView.backgroundColor = .randomColor
        
        let ivSprite = UIFactory.createImage(name: "")
        let lbId = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let lbName = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        let lbTypes = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let btnFavorite = UIFactory.createImageButton(name: "")
        
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
        
        btnFavorite.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        
        let margin = 20*scale
        let itemInset = 15*scale
        
        ivSprite.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(margin)
            make.width.equalTo(44*scale)
            make.height.equalTo(44*scale)
        }
        
        lbId.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(2*scale)
            make.leading.equalTo(ivSprite.snp.trailing).offset(itemInset)
            make.trailing.equalTo(btnFavorite.snp.leading).offset(-itemInset)
            make.height.equalTo(15*scale)
        }
        
        lbName.snp.makeConstraints { make in
            make.top.equalTo(lbId.snp.bottom).offset(0*scale)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
            make.height.equalTo(15*scale)
        }
        
        lbTypes.snp.makeConstraints { make in
            make.top.equalTo(lbName.snp.bottom).offset(0*scale)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
            make.height.equalTo(15*scale)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-margin)
            make.width.equalTo(44*scale)
            make.height.equalTo(44*scale)
        }
    }
    
    override func setupWithItem(item: HomePokemonListModel) {
        self.item = item
        
        lbName?.text = item.name
        lbId?.text = String(item.id)
        lbTypes?.text = item.types.joined(separator: ", ")
        
        ivSprite?.image = nil
        if let ivSprite = self.ivSprite, !item.imageUrlStr.isEmpty {
            imageLoader.downloadImage(iv: ivSprite, urlStr: item.imageUrlStr)
        } else {
            print()
        }
        
        btnFavorite?.setBackgroundImage(UIFactory.getImage(named: item.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc func btnFavoriteTapped() {
        print(#function)
    }
}
    
