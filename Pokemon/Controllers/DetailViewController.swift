//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/23.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {
    let scale: CGFloat = UIFactory.getScale()
    var pokemonDetailViewModel: PokemonDetailViewModel!
    let pokemonSpeciesViewModel = PokemonSpeciesViewModel()
    let pokemonEvolutionChainViewModel = PokemonEvolutionChainViewModel()
    var homeListModel: HomePokemonListModel!
    
    var refreshControl: UIRefreshControl!
    var infoView: DetailInfoView!
    var flavorView: DetailFlavorView!
    var evolutionView: DetailEvolutionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    deinit {
        print("\(type(of: self)) deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    init(pokemonDetailViewModel: PokemonDetailViewModel, homeListModel: HomePokemonListModel) {
        super.init(nibName: nil, bundle: nil)
        self.pokemonDetailViewModel = pokemonDetailViewModel
        pokemonDetailViewModel.delegate = self
        pokemonEvolutionChainViewModel.delegate = self
        self.homeListModel = homeListModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        pokemonDetailViewModel?.delegate = self
        pokemonSpeciesViewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "DetailView"
        
        setupUI()
        setupSubscribers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestAPIs(isRefresh: false)
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = ColorFactory.white2
        
        // UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90*scale, right: 0)
        view.addSubview(scrollView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ColorFactory.greyishBrown
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        // contentView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.leading.equalTo(scrollView.frameLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.frameLayoutGuide.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
        }
        
        // main stack
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(55*scale)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        // infoView
        let infoView = DetailInfoView()
        view.addSubview(infoView)
        self.infoView = infoView
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(100*scale)
        }
        mainStackView.addArrangedSubview(infoView)
        infoView.btnFavoriteAction = {
            NotificationCenter.default.post(name: .dataUpdatedNotification, object: nil)
        }
        
        // flavorView
        let flavorView = DetailFlavorView()
        flavorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flavorView)
        self.flavorView = flavorView
        flavorView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        mainStackView.addArrangedSubview(flavorView)
        
        // evolutionView
        let evolutionView = DetailEvolutionView()
        evolutionView.axis = .vertical
        evolutionView.spacing = 0
        evolutionView.delegate = self
        self.evolutionView = evolutionView
        mainStackView.addArrangedSubview(evolutionView)
        
        // btnBack
        let btnBack = UIFactory.createImageButton(name: "chevron.backward.circle.fill", tintColor: ColorFactory.hotpink)
        view.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10*scale)
            make.leading.equalTo(view.snp.leading).offset(10*scale)
            make.width.equalTo(44*scale)
            make.height.equalTo(44*scale)
        }
        btnBack.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
    }
    
    @objc func btnBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController {
    func setupSubscribers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdated), name: .dataUpdatedNotification, object: nil)
    }
    
    @objc func handleDataUpdated() {
        infoView.updateFavoriteUI()
    }
}

extension DetailViewController {
    func requestAPIs(isRefresh: Bool) {
        let pokemonId = homeListModel.id
        let name = homeListModel.name
        
        pokemonDetailViewModel.loadData(isRefresh: false, id: pokemonId, name: name)
    }
    
    @objc func handleRefresh() {
        requestAPIs(isRefresh: true)
        self.refreshControl?.endRefreshing()
    }
}

extension DetailViewController: PokemonDetailViewModelProtocol {
    func updatePokemonDetailUI(pokemonDetailModel: PokemonDetailModel) {
        guard let realmObj = RealmManager.getPokemon(byID: pokemonDetailModel.id) else {
            return
        }
        let item = HomePokemonListModel(id: realmObj.pokemonID, name: realmObj.name, imageUrlStr: realmObj.spriteFrontUrl, types: Array(realmObj.types), isFavorite: realmObj.isFavorite)
        infoView.setupContent(item: item)
        
        pokemonSpeciesViewModel.loadData(isRefresh: false, id: realmObj.pokemonID, name: realmObj.name)
    }
}

extension DetailViewController: PokemonSpeciesViewModelProtocol {
    func updatePokemonSpeciesUI(pokemonSpeciesModel: PokemonSpeciesModel) {
        print("updatePokemonSpeciesUI")
        flavorView.setupContent(item: pokemonSpeciesModel)
        
        if let evolutionChainId = pokemonSpeciesViewModel.getEvolutionChainId() {
            pokemonEvolutionChainViewModel.loadData(isRefresh: false, id: evolutionChainId)
        }
    }
}

extension DetailViewController: PokemonEvolutionChainViewModelProtocol {
    func updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: PokemonEvolutionChainModel, speciesList: [[PokemonSpecies]]) {
        evolutionView?.setupContent(itemsList: speciesList)
    }
}

extension DetailViewController: DetailEvolutionViewProtocol {
    func detailEvolutionViewTapped(pokemonSpecies: PokemonSpecies) {
        let id = pokemonSpecies.speciesId
        guard let name = pokemonSpecies.name else {
            return
        }
        var isFavorite = false
        if let realmObj = RealmManager.getPokemon(byID: id) {
            isFavorite = realmObj.isFavorite
        }
        let item = HomePokemonListModel(id: id, name: name, imageUrlStr: "", types: [], isFavorite: isFavorite)
        let vc = DetailViewController(pokemonDetailViewModel: pokemonDetailViewModel, homeListModel: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
