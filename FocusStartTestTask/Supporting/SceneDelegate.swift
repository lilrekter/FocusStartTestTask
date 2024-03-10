//
//  SceneDelegate.swift
//  FocusStartTestTask
//
//  Created by Vitaly on 10.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
        
        setupNavController()
    }
    
    private func setupNavController() {
        let nav = UINavigationController(rootViewController: NotesListViewController())
        nav.modalPresentationStyle = .fullScreen
        nav.navigationItem.largeTitleDisplayMode = .automatic
        self.window?.rootViewController = nav
    }
}

