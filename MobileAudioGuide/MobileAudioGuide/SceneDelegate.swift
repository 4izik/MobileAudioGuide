//
//  SceneDelegate.swift
//  MobileAudioGuide
//
//  Created by Настя on 15.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let excursionsInfo = ExcursionsPlistLoader.loadExcursionInfo()
            let navigationController = UINavigationController.init(rootViewController: MainViewController(excursionsInfo: excursionsInfo))
            setupNavigationController(navigationController)
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func setupNavigationController(_ navigationController: UINavigationController) {
        let navigationBar = navigationController.navigationBar
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.appAccentColor
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
    }
}
