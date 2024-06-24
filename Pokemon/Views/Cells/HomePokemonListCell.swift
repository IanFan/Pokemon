//
//  HomePokemonListCell.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

protocol HomePokemonCellProtocol: AnyObject {
    func homePokemonCellFavoriteUpdated()
}

class HomePokemonCell: UICollectionViewCell, PokemonDetailViewModelProtocol {
    let scale: CGFloat = UIFactory.getScale()
    weak var delegate: HomePokemonCellProtocol?
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
        let ivSprite = UIFactory.createImage(name: "")
        let lbId = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let lbName = UIFactory.createLabel(size: 18*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCMedium)
        let lbTypes = UIFactory.createLabel(size: 14*scale, text: "", color: ColorFactory.greyishBrown, font: .PingFangTCRegular)
        let btnFavorite = UIFactory.createImageButton(name: "", tintColor: ColorFactory.heartRed)
        let vSeperate = UIFactory.createView(color: .black.withAlphaComponent(0.1))
        
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
        contentView.addSubview(vSeperate)
        
        ivSprite.contentMode = .scaleAspectFit
        
        btnFavorite.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        
        let margin = 20*scale
        let itemInset = 15*scale
        
        ivSprite.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(margin)
            make.width.equalTo(80*scale)
            make.height.equalTo(80*scale)
        }
        
        lbId.snp.makeConstraints { make in
            make.bottom.equalTo(lbName.snp.top)
            make.leading.equalTo(ivSprite.snp.trailing).offset(itemInset)
            make.trailing.equalTo(btnFavorite.snp.leading).offset(-itemInset)
        }
        
        lbName.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
        }
        
        lbTypes.snp.makeConstraints { make in
            make.top.equalTo(lbName.snp.bottom)
            make.leading.equalTo(lbId.snp.leading)
            make.trailing.equalTo(lbId.snp.trailing)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-margin)
            make.width.equalTo(36*scale)
            make.height.equalTo(36*scale)
        }
        
        vSeperate.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-1)
            make.leading.equalTo(contentView.snp.leading).offset(100*scale)
            make.trailing.equalTo(contentView.snp.trailing).offset(-margin)
            make.height.equalTo(1)
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
    
