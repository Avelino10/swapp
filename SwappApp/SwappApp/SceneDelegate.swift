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

        let swappViewController = PeopleUIComposer.launchComposedWith(loader: loader)

        window?.rootViewController = swappViewController
    }
}
