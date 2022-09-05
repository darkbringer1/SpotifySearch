//
//  HomeFactory.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit

final class HomeFactory {
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func createHomeView(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let dataHandler = HomeViewDataHandler()
        
        let profileService = ProfileService(configuration: dependencyContainer.apiConfiguration)
        let searchService = SearchService(configuration: dependencyContainer.apiConfiguration)
        
        let homeViewModel = HomeViewModel(
            profileService: profileService,
            searchService: searchService,
            dataHandler: dataHandler,
            observationManager: dependencyContainer.observationManager
        )
        
        homeViewModel.coordinatorDelegate = coordinatorDelegate
        
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.title = "Search"
        homeViewController.navigationController?.navigationBar.prefersLargeTitles = true
        return homeViewController
    }
    
    func createSignInScreen(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let viewModel = SignInViewModel()
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = SignInViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func createProfileScreen(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let viewModel = ProfileViewModel()
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = ProfileViewController(viewModel: viewModel)
        viewController.title = "Profile"
        
        return viewController
    }
    
    func createAuthView(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        
        let viewModel = AuthorizationViewModel(
            observationManager: dependencyContainer.observationManager
        )
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = AuthorizationViewController(viewModel: viewModel)
        viewController.title = "Sign In"
        return viewController
    }
}
