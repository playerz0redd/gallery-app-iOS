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
        
        let mainTabBar = MainTabBar(nibName: nil, bundle: nil)
        
        window.rootViewController = mainTabBar
        window.makeKeyAndVisible()
        self.window = window
    }
}

