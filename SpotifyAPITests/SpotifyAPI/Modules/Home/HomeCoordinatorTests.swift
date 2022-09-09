//
//  HomeCoordinatorTests.swift
//  SpotifyAPITests
//
//  Created by Can Yoldaş on 8.09.2022.
//

import Foundation
import XCTest
@testable import SpotifyAPI

final class HomeCoordinatorTests: XCTestCase {
    
    private var sut: HomeCoordinator!
    private var window: UIWindow!
    private var parentCoordinator: MockParentCoordinator!
    private var authManager: MockAuthManager!
    
    override func setUp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let observationManager = ObservationManager()
        authManager = MockAuthManager(observationManager: observationManager)
        
        let dependencies = DependencyContainer(
            window: window,
            apiConfiguration: URLSessionConfiguration.default,
            observationManager: observationManager,
            authManager: authManager
        )
        parentCoordinator = MockParentCoordinator()
        sut = HomeCoordinator(dependencies: dependencies)
        sut.parentCoordinator = parentCoordinator
        
        window.rootViewController = sut.rootViewController
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        sut = nil
        parentCoordinator = nil
        authManager = nil
        window = nil
        super.tearDown()
    }
    
    func testStartOfCoordinator() {
        // When
        sut.start()
        
        // Then
        XCTAssertNotNil(sut.rootViewController)
        XCTAssertTrue(sut.rootViewController.viewControllers.first is HomeViewController)
    }
    
    func testChildDidFinish() {
        // When
        sut.dismiss()
        
        // Then
        XCTAssertTrue(parentCoordinator.childDidFinishedCalled)
    }
    
    func testGoToLogin() {
        // Given
        sut.start()
        window.rootViewController = sut.rootViewController
        window.makeKeyAndVisible()
        
        // When
        sut.goToLogin()
        
        // Then
        XCTAssertTrue(sut.rootViewController.presentedViewController is SignInViewController)
    }
    
    func testGoToDetail() {
        // Given
        sut.start()

        // When
        sut.goToDetail(animated: false, with: "Test")
        
        // Then
        XCTAssertTrue(sut.rootViewController.topViewController is DetailViewController)
    }
    
//    func testGoToAuth() {
//        // Given
//        sut.start()
//        window.rootViewController = sut.rootViewController
//        window.makeKeyAndVisible()
//
//        sut.goToAuthScreen()
//
//        XCTAssertTrue(sut.rootViewController.presentedViewController is AuthorizationViewController)
//
//    }
    
}

fileprivate class MockParentCoordinator: ParentCoordinatorDelegate {
    
    var children: [CoordinatorProtocol] = []
    
    var childDidFinishedCalled = false
    
    func childDidFinish(child: CoordinatorProtocol) {
        childDidFinishedCalled = true
    }
    
}

fileprivate class MockAuthManager: AuthManagerProtocol {
    
    var observationManager: SpotifyAPI.ObservationManagerProtocol
    
    init(observationManager: SpotifyAPI.ObservationManagerProtocol) {
        self.observationManager = observationManager
    }
    
    func isSignedIn() -> Bool {
        print("also here")
        return true
    }
    
    func getSignInUrl() -> URL? {
        nil
    }
    
    func removeCacheIfNeeded() { }
    
    func logout() { }
    
    func exchangeCodeForToken(code: String, completion: @escaping SpotifyAPI.GenericHandler<Bool>) {
        //
    }
    
    func fetchData<T>(
        endpoint: String,
        httpMethod: SpotifyAPI.HTTPMethod,
        requestable: SpotifyAPI.Requestable,
        completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
        //
    }
    
    
}
