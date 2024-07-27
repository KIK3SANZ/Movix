//
//  AppDelegate.swift
//  Movix
//
//  Created by Enrique Sanz on 26/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieListViewController = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController {
            movieListViewController.viewModel = DependencyInjector.shared.makeMovieListViewModel()
            let navigationController = UINavigationController(rootViewController: movieListViewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        return true
    }

}

