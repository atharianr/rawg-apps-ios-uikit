//
//  SceneDelegate.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 22/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        if !UserDefaults.standard.bool(forKey: "first") {
            ProfileDummyData().addDummyData {
                UserDefaults.standard.set(true, forKey: "first")
                debugPrint("userDefaults first2 -> \(UserDefaults.standard.bool(forKey: "first"))")
            }
        }

        guard (scene as? UIWindowScene) != nil else { return }
    }
}
