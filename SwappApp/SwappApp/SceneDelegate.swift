//
//  SceneDelegate.swift
//  SwappApp
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import SwappiOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let peopleURL = URL(string: "https://swapi.dev/api/people")!

        let remoteClient = URLSessionHTTPClient(session: .shared)
        let loader = RemoteStarWarsLoader(url: peopleURL, client: remoteClient)
        let imageLoader = RemoteStarWarsImageDataLoader(client: remoteClient)

        let swappViewController = PeopleUIComposer.launchComposedWith(loader: loader, imageDataLoader: imageLoader)

        let bundle = Bundle(for: SceneDelegate.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let aboutViewController = storyboard.instantiateInitialViewController()!

        let charactersTabBarItem = UITabBarItem(title: "Characters", image: nil, selectedImage: nil)
        let aboutTabBarItem = UITabBarItem(title: "About", image: nil, selectedImage: nil)

        swappViewController.tabBarItem = charactersTabBarItem
        aboutViewController.tabBarItem = aboutTabBarItem

        let tabBar = UITabBarController()
        tabBar.setViewControllers([swappViewController, aboutViewController], animated: true)
        window?.rootViewController = tabBar
    }
}
