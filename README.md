# Pokemon Project


## Overview

The Pokemon Project is an iOS application designed to display a list of Pokémon, allowing users to view detailed information about each Pokémon, including their species and evolution chains. Users can switch between list and grid views and favorite their preferred Pokémon.


## Features

Home View: Displays a list or grid of Pokémon.
Detail View: Shows detailed information about a Pokémon, including basic info, species, and evolution chain.
Favorite Functionality: Users can favorite their preferred Pokémon and view them in a dedicated favorites view.
Interface Switching: Supports switching between list and grid views.


## Structure and Design Pattern

The Swift project follows a structured approach integrating MVVM architecture for clear separation of Models, Views, and ViewModels like PokemonListViewModel for data management. It employs Dependency Inversion Principle and Strategy pattern in the data loader for flexibility, alongside a protocol-delegate pattern in views for modular code. Supporting utilities, services, and helpers enhance functionality, ensuring efficient data handling and UI management throughout the application.

### MVVM
Models: 
    This typically includes your data structures and models that represent the data the app works with.

Views: 
    These are the visual elements and components that users interact with. The protocol-delegate pattern in a custom view to simplify communication with its containing view controller.

ViewModels: 
    PokemonListViewModel: Manages the list of Pokémon, handling fetching from a data source.
    PokemonDetailViewModel: Provides detailed information about a Pokémon.
    PokemonSpeciesViewModel: Handles data specific to Pokémon species.
    PokemonEvolutionChainViewModel: Manages the evolution chain for a Pokémon.
    PokemonTypeViewModel: Deals with Pokémon types.
    DownloadImageViewModel: Manages the downloading and caching of images used in the app.

Controllers: 
    Responsible for managing the flow of the application and responding to user input.

Services: 
    Handles loading data from various sources (like network requests or local storage).

Utilities:
    UIFactory: Provides methods to create UI components programmatically.
    FontFactory: Manages and provides access to fonts used in the app.
    ColorFactory: Centralizes color management and access.
    AnimationHelper: Assists with animations and transitions.
    LanguageManager: Handles localization and language-specific configurations.
    RealmManager: Manages interactions with the Realm database.

Helpers: 
    JsonHelper provides utility functions for working with JSON data.

Extensions: 
    Additional functionalities or enhancements for existing Swift types, often used to extend their capabilities.


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
