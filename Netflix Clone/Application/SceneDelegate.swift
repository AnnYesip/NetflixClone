//
//  SceneDelegate.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
//    var appCoordinator: TabCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(navigationController)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user == nil {
                //пользователь не авторизирован
                print("пользователь не авторизирован")
                self?.appCoordinator?.showLoginFlow()
            } else {
                print(user)
                self?.appCoordinator?.showMainFlow()
            }
        }
    }

}

