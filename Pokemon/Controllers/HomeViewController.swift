//
//  HomeViewController.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let scale: CGFloat = UIFactory.getScale()
    let pokemonListViewModel = PokemonListViewModel()
    let pokemonDetailViewModel = PokemonDetailViewModel()
    let pokemonTypeViewModel = PokemonTypeViewModel()
    
    let cellID = "cellID"
    var cv: UICollectionView!
    var refreshControl: UIRefreshControl!
    var navigationHeader: HomeNavigationHeader?
    var isShowFavorite: Bool = false
    var isShowGrid: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmManager.deleteAllPokemon()
        
        pokemonListViewModel.delegate = self
        pokemonDetailViewModel.delegate = self
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestAPIs(isRefresh: false)
        }
    }
    
    func setupUI() {
        // collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
//        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        // register cells
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        cv.register(HomePokemonListCell.self, forCellWithReuseIdentifier: HomePokemonListCell.cellID)
        cv.register(HomePokemonGridCell.self, forCellWithReuseIdentifier: HomePokemonGridCell.cellID)
        //register headers
        cv.register(HomeNavigationHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeNavigationHeader.headerID)
        //register footers
//        cv.register(HomeFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeFooter.footerID)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIFactory.isPad() ? 0*scale : 0*scale, right: 0)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        view.addSubview(cv)
        self.cv = cv
        
        // pull refresh
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = ColorFactory.greyishBrown
        refreshControl.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
        cv.refreshControl = refreshControl
        self.refreshControl = refreshControl
        
        // layout
        cv.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func requestAPIs(isRefresh: Bool) {
        pokemonListViewModel.loadData(isRefresh: isRefresh)
//        pokemonDetailViewModel.loadData(name: "bulbasaur", id: 1)
//        pokemonTypeViewModel.loadData(isRefresh: isRefresh)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = pokemonListViewModel.getPokemonListCount(isShowFavorite: isShowFavorite)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let section = indexPath.section
        let row = indexPath.row
        
        let objs = pokemonListViewModel.getPokemonList(isShowFavorite: isShowFavorite)
        let obj = objs[row]
        if obj.id == 0 {
            print()
        }
        
        let realmObj = RealmManager.getPokemon(byID: obj.id)!
        let item = HomePokemonListModel(id: realmObj.pokemonID, name: realmObj.name, imageUrlStr: realmObj.spriteFrontUrl, types: Array(realmObj.types), isFavorite: realmObj.isFavorite)
        
        if !isShowFavorite, row == objs.count-1 {
            pokemonListViewModel.loadData(isRefresh: false)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: isShowGrid ? HomePokemonGridCell.cellID : HomePokemonListCell.cellID, for: indexPath) as! HomePokemonCell
        cell.delegate = self
        cell.setupWithItem(item: item)
        cell.loadDetailData(item: item)
        return cell
//        return collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectSectionIndex = indexPath.section
        let selectIndex = indexPath.item
        print("select:\(indexPath.section) \(indexPath.row)")
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomePokemonCell, let item: HomePokemonListModel = cell.item else {
            return
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // header
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeNavigationHeader.headerID, for: indexPath) as! HomeNavigationHeader
            header.delegate = self
            let item = HomeNavigationModel(isShowFavorite: isShowFavorite, isShowGrid: isShowGrid)
            header.setupWithItem(item: item)
            self.navigationHeader = header
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            return UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let width = collectionView.frame.width
        if isShowGrid {
            let itemsPerRow: CGFloat = 4
            var cellWidth = floor(width/itemsPerRow)
            return CGSize(width: cellWidth, height: cellWidth)
        } else {
            return CGSize(width: width, height: 48*scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 50*scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        let width = collectionView.frame.width
        return CGSize.zero
    }
}

extension HomeViewController {
    @objc func refreshCollectionView(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
        }
    }
}

extension HomeViewController: PokemonListViewModelProtocol {
    func updatePokemonListUI(loadMorePokemons: [PokemonListModel]) {
        print(#function)
        if isShowFavorite {
            cv?.reloadData()
        } else {
            if cv?.visibleCells.count ?? 0 == 0 {
                cv?.reloadData()
            } else {
                cv?.performBatchUpdates({
                    let dataCount = pokemonListViewModel.getPokemonListCount(isShowFavorite: isShowFavorite)
                    let startIndex = dataCount - loadMorePokemons.count
                    var indexPathsToInsert = [IndexPath]()
                    for i in startIndex..<dataCount {
                        let indexPath = IndexPath(item: i, section: 0)
                        indexPathsToInsert.append(indexPath)
                    }
                    cv?.insertItems(at: indexPathsToInsert)
                }, completion: nil)
            }
        }
    }
}

extension HomeViewController: PokemonDetailViewModelProtocol {
    func updatePokemonDetailUI(pokemonDetailModel: PokemonDetailModel) {
//        print(#function)
        guard let cv = self.cv,
              let realObj = RealmManager.getPokemon(byID: pokemonDetailModel.id) else {
            return
        }
    }
}

extension HomeViewController: HomeNavigationHeaderProtocol {
    func showFavoriteSwitched(isFavorite: Bool) {
        self.isShowFavorite = isFavorite
        pokemonListViewModel.updateFavoritePokemons()
        cv?.reloadData()
    }
    
    func listGridSwitched(isShowGrid: Bool) {
        self.isShowGrid = isShowGrid
        cv?.reloadData()
    }
}

extension HomeViewController: HomePokemonCellProtocol {
    func homePokemonCellFavoriteUpdated() {
        if isShowFavorite {
            pokemonListViewModel.updateFavoritePokemons()
            if pokemonListViewModel.getPokemonList(isShowFavorite: isShowFavorite).count > 0 {
                cv?.reloadData()
            } else {
                navigationHeader?.btnFavoriteTapped()
                cv?.reloadData()
            }
        }
    }
}
