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
        contentView.backgroundColor = ColorFactory.white2
        
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
        NSLayoutConstraint.activate([
            ivSprite.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ivSprite.leadingAnchor.constraint(equalTo: ivSprite.leadingAnchor, constant: margin),
            ivSprite.widthAnchor.constraint(equalToConstant: 44*scale),
            ivSprite.heightAnchor.constraint(equalToConstant: 44*scale),
            
            lbId.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2*scale),
            lbId.leadingAnchor.constraint(equalTo: ivSprite.trailingAnchor, constant: itemInset),
            lbId.trailingAnchor.constraint(equalTo: btnFavorite.leadingAnchor, constant: -itemInset),
            lbId.heightAnchor.constraint(equalToConstant: 15*scale),
            
            lbName.topAnchor.constraint(equalTo: lbId.bottomAnchor, constant: 0*scale),
            lbName.leadingAnchor.constraint(equalTo: lbId.leadingAnchor),
            lbName.trailingAnchor.constraint(equalTo: lbId.trailingAnchor),
            lbName.heightAnchor.constraint(equalToConstant: 15*scale),
            
            lbTypes.topAnchor.constraint(equalTo: lbName.bottomAnchor, constant: 0*scale),
            lbTypes.leadingAnchor.constraint(equalTo: lbName.leadingAnchor),
            lbTypes.trailingAnchor.constraint(equalTo: lbName.trailingAnchor),
            lbTypes.heightAnchor.constraint(equalToConstant: 15*scale),
            
            btnFavorite.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            btnFavorite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            btnFavorite.widthAnchor.constraint(equalToConstant: 44*scale),
            btnFavorite.heightAnchor.constraint(equalToConstant: 44*scale),
        ])
    }
    
    override func setupWithItem(item: HomePokemonListModel) {
        self.item = item
        
        lbName?.text = item.name
        lbId?.text = String(item.id)
        lbTypes?.text = item.types.joined(separator: ", ")
        
        if let ivSprite = self.ivSprite, !item.imageUrlStr.isEmpty {
            imageLoader.downloadImage(iv: ivSprite, urlStr: item.imageUrlStr)
        }
    }
    
    @objc func btnFavoriteTapped() {
        
    }
}
