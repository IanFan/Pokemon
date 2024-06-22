//
//  HomeNavigationHeader.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

protocol HomeNavigationHeaderProtocol: AnyObject {
}

class HomeNavigationHeader: UICollectionReusableView {
    static let headerID = "HomeNavigationHeader"

    weak var delegate: HomeNavigationHeaderProtocol?
    let scale: CGFloat = UIFactory.getScale()
    
    var item: HomeNavigationModel?
    var btnFavorite: UIButton?
    var btnListGrid: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = ColorFactory.white2
        
        let btnFavorite = UIFactory.createImageButton(name: "", tintColor: .red)
        let btnListGrid = UIFactory.createImageButton(name: "", tintColor: .black)
        
        self.btnFavorite = btnFavorite
        self.btnListGrid = btnListGrid
        
        addSubview(btnFavorite)
        addSubview(btnListGrid)
        
        btnFavorite.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        btnListGrid.addTarget(self, action: #selector(btnListGridTapped), for: .touchUpInside)
        
        let margin = 20*scale
        let itemInset = 15*scale
        
        btnFavorite.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-margin)
            make.width.equalTo(44*scale)
            make.height.equalTo(44*scale)
        }
        
        btnListGrid.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(btnFavorite.snp.leading).offset(-itemInset)
            make.width.equalTo(44*scale)
            make.height.equalTo(44*scale)
        }
    }
    
    func setupWithItem(item: HomeNavigationModel) {
        self.item = item
        
        btnFavorite?.setBackgroundImage(UIFactory.getImage(named: item.isShowFavorite ? "heart.fill" : "heart"), for: .normal)
        btnListGrid?.setBackgroundImage(UIFactory.getImage(named: item.isShowGrid ? "square.grid.2x2" : "rectangle.grid.1x2"), for: .normal)
    }
    
    @objc func btnFavoriteTapped() {
        print(#function)
    }
    
    @objc func btnListGridTapped() {
        print(#function)
    }
}
