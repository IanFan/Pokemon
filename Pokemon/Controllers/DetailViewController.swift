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
    var homeListModel: HomePokemonListModel!
    
    var refreshControl: UIRefreshControl!
    var infoView: DetailInfoView!
    var flavorView: DetailFlavorView!
//    var evolutionView: DetailEvolutionView!
    
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
        self.homeListModel = homeListModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
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
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        // infoView
        let infoView = DetailInfoView(frame: .zero, item: homeListModel)
        infoView.backgroundColor = .randomColor
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
        flavorView.backgroundColor = .randomColor
        view.addSubview(flavorView)
        self.flavorView = flavorView
        flavorView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        mainStackView.addArrangedSubview(flavorView)
        flavorView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func requestAPIs(isRefresh: Bool) {
        let pokemonId = homeListModel.id
        let name = homeListModel.name
        guard let realmPokemon = RealmManager.getPokemon(byID: pokemonId) else {
            return
        }
        
        pokemonSpeciesViewModel.loadData(isRefresh: isRefresh, id: pokemonId, name: name)
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
    @objc func handleRefresh() {
        self.refreshControl?.endRefreshing()
    }
}

extension DetailViewController: PokemonDetailViewModelProtocol {
    func updatePokemonDetailUI(pokemonDetailModel: PokemonDetailModel) {
        
    }
}

extension DetailViewController: PokemonSpeciesViewModelProtocol {
    func updatePokemonSpeciesUI(pokemonSpeciesModel: PokemonSpeciesModel) {
        print("updatePokemonSpeciesUI")
        flavorView.setupContent(item: pokemonSpeciesModel)
        self.view.layoutIfNeeded()
    }
}
