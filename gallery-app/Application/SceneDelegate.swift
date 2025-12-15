//
//  SceneDelegate.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let networkManager = NetworkManager()
        let persistanceManager = CoreDataManager.shared
        let viewModel = GalleryViewModel(
            photoService: .init(dataProvider: networkManager, modelProvider: networkManager, persistanceManager: persistanceManager)
        )
        
        let likedPhotosViewModel = GalleryViewModel(
            photoService: .init(dataProvider: networkManager, modelProvider: persistanceManager, persistanceManager: persistanceManager)
        )
        
        let likedPhotosViewController = GalleryViewController(viewModel: likedPhotosViewModel)
        
        let likedNavController = UINavigationController(rootViewController: likedPhotosViewController)
        likedNavController.navigationBar.prefersLargeTitles = false
        
        
        let rootViewController = GalleryViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = false
        
        rootViewController.tabBarItem = .init(
            title: "",
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 0
        )
        
        likedNavController.tabBarItem = .init(
            title: "",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        let tabBarView = UITabBarController()
        tabBarView.viewControllers = [navigationController, likedNavController]
        tabBarView.tabBar.tintColor = .systemBlue
        
        window.rootViewController = tabBarView
        window.makeKeyAndVisible()
        self.window = window
    }

}

