//
//  SceneDelegate.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return assertionFailure() }
		window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else { return assertionFailure() }
		window.windowScene = windowScene
		window.rootViewController = ViewController()
		window.makeKeyAndVisible()
	}
}

