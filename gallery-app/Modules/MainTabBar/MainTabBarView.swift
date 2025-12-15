//
//  View.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 16.12.25.
//

import UIKit

final class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
    }
    
    private func setupViewControllers() {
        
        let networkManager: NetworkManager = .init()
        let persistanceManager: CoreDataManager = .shared
        
        let galleryViewController = GalleryModuleBuilder.build(
            dataProvider: networkManager,
            persistanceProvider: persistanceManager,
            type: .gallery
        )
        
        let favoritesViewController = GalleryModuleBuilder.build(
            dataProvider: networkManager,
            persistanceProvider: persistanceManager,
            type: .favorites
        )
        
        let galleryNavController = createNavController(
            for: galleryViewController,
            with: .init(systemName: GalleryModuleBuilder.GalleryModuleType.gallery.imageName)
        )
        
        let favoritesNavController = createNavController(
            for: favoritesViewController,
            with: .init(systemName: GalleryModuleBuilder.GalleryModuleType.favorites.imageName)
        )
        
        viewControllers = [galleryNavController, favoritesNavController]
        
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        with image: UIImage?
    ) -> UINavigationController {
        let navController: UINavigationController = .init(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = false
        
        navController.tabBarItem.image = image
        navController.tabBarItem.title = nil
        
        return navController
    }
}
