# Pokemon Project


## Overview

The Pokemon Project is an iOS application designed to display a list of Pokémon, allowing users to view detailed information about each Pokémon, including their species and evolution chains. Users can switch between list and grid views and favorite their preferred Pokémon.


## Features

Home View: Displays a list or grid of Pokémon. Users can refresh the data by pulling down.
Detail View: Shows detailed information about a Pokémon, including basic info, species, and evolution chain.
Favorite Functionality: Users can favorite their preferred Pokémon and view them in a dedicated favorites view.
Interface Switching: Supports switching between list and grid views.


## Structure and Design Pattern

In this MVVM architecture, the data loader component is implemented using the Dependency Inversion Principle (DIP) and the Strategy pattern.


## Main Files

### HomeViewController.swift
HomeViewController is the main view controller responsible for displaying the Pokémon list or grid and handling user interactions.

#### Key Properties

pokemonListViewModel: ViewModel managing the Pokémon list data.
pokemonDetailViewModel: ViewModel managing the Pokémon detail data.
cv: UICollectionView for displaying the Pokémon list or grid.
navigationView: Custom navigation view for switching views and favorites.

#### Key Methods

setupUI(): Initializes the user interface.
requestAPIs(isRefresh: Bool): Requests Pokémon list data.
setupSubscribers(): Sets up notification subscribers.
refreshCollectionView(_ sender: UIRefreshControl): Handles pull-to-refresh action.
updatePokemonListUI(loadMorePokemons: [PokemonListModel]): Updates the Pokémon list UI.
showFavoriteSwitched(isFavorite: Bool): Handles the switching of the favorite view.
listGridSwitched(isShowGrid: Bool): Handles the switching between list and grid views.

### DetailViewController.swift
DetailViewController is the detail view controller responsible for displaying detailed information about a Pokémon, including basic info, species, and evolution chain.

#### Key Properties

pokemonDetailViewModel: ViewModel managing the Pokémon detail data.
pokemonSpeciesViewModel: ViewModel managing the Pokémon species data.
pokemonEvolutionChainViewModel: ViewModel managing the Pokémon evolution chain data.
homeListModel: Pokémon data model passed from the home view.

#### Key Methods

setupUI(): Initializes the user interface.
setupSubscribers(): Sets up notification subscribers.
requestAPIs(isRefresh: Bool): Requests Pokémon detail data.
updatePokemonDetailUI(pokemonDetailModel: PokemonDetailModel): Updates the Pokémon detail UI.
updatePokemonSpeciesUI(pokemonSpeciesModel: PokemonSpeciesModel): Updates the Pokémon species UI.
updatePokemonEvolutionChainUI(pokemonEvolutionChainModel: PokemonEvolutionChainModel, speciesList: [[PokemonSpecies]]): Updates the Pokémon evolution chain UI.


## Usage

### Installing Dependencies
This project uses Swift Package Manager to handle dependencies. Ensure you have added the following packages to your project:

SnapKit
Realm


## Customization
You can customize the following:

UI Styles: Modify colors and styles in UIFactory and ColorFactory.
Data Models: Adjust the PokemonListViewModel, PokemonDetailViewModel, PokemonSpeciesViewModel, and PokemonEvolutionChainViewModel to fit different data sources.


## LLM Tools

Assisting with ReadMe Descriptions
Searching for Suitable Third-Party Packages
Providing Code Reviews and Suggestions
Automating Repetitive Tasks
Creating Test Cases
Refactoring Code
Explaining Complex Code


## Contributing

We welcome contributions to this project. You can contribute by:

Forking this project.
Creating your branch: git checkout -b feature-branch
Committing your changes: git commit -am 'Add new feature'
Pushing to your branch: git push origin feature-branch
Creating a Pull Request.
License

This project is licensed under the MIT License. See the LICENSE file for details.
