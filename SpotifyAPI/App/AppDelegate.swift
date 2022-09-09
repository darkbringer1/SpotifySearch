//
//  AppDelegate.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dependencyContainer: DependencyContainer!
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let apiConfiguration = URLSessionConfiguration.default
        apiConfiguration.waitsForConnectivity = true
        apiConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // Auth Manager should have the the same instance of the observation to notify all view models.
        let observationManager = ObservationManager()
        let authManager = AuthManager(
            observationManager: observationManager,
            authService: AuthService(configuration: apiConfiguration)
        )
        
        // When user opens the app, removes the tokens if they are expired.
        authManager.removeCacheIfNeeded()
        
        dependencyContainer = DependencyContainer(
            window: window,
            apiConfiguration: apiConfiguration,
            observationManager: observationManager,
            authManager: authManager
        )
        
        appCoordinator = CoordinatorFactory.buildAppCoordinator(dependencies: dependencyContainer)
        appCoordinator?.start()
                
        window.rootViewController = appCoordinator?.rootViewController
        window.makeKeyAndVisible()
        return true
    }

}

