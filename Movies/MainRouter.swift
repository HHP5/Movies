//
//  MainRouter.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

class MainRouter {
	private let tabbar: UITabBarController
	
	private let firstNavController: UINavigationController
	
	private let firstViewController: PopularViewController
	
	private let secondNavController: UINavigationController
	private let secondViewController: PopularViewController
	
	private let thirdNavController: UINavigationController
	private let thirdViewController: SearchViewController
	
	private let fourthNavController: UINavigationController
	private let fourthViewController: FavouritesViewController
	
	internal init() {
		self.tabbar = UITabBarController()

		self.firstViewController = PopularViewController(viewModel: PopularTopSearchViewModel(type: .popular))
		self.firstNavController = UINavigationController(rootViewController: self.firstViewController)
		
		self.secondViewController = PopularViewController(viewModel: PopularTopSearchViewModel(type: .top))
		self.secondNavController = UINavigationController(rootViewController: self.secondViewController)
		
		self.thirdViewController = SearchViewController(viewModel: PopularTopSearchViewModel(type: .search))
		self.thirdNavController = UINavigationController(rootViewController: self.thirdViewController)
		
		self.fourthViewController = FavouritesViewController(viewModel: FavouritesViewModel())
		self.fourthNavController = UINavigationController(rootViewController: self.fourthViewController)
		
		self.configFirstViewController()
		self.configSecondViewController()
		self.configThirdViewController()
		self.configFourthViewController()
		
		self.tabbar.setViewControllers([self.firstNavController,
										self.secondNavController,
										self.thirdNavController,
										self.fourthNavController],
									   animated: true)
		
	}
	
	internal func tabBar() -> UITabBarController {
		return self.tabbar
	}
	
	private func configFirstViewController() {
		self.firstViewController.view.backgroundColor = .white
		
		self.firstNavController.tabBarItem.title = "Popular"
		self.firstNavController.tabBarItem.image = UIImage(systemName: "video")
		self.firstNavController.navigationBar.isHidden = true
	}
	
	private func configSecondViewController() {
		self.secondViewController.view.backgroundColor = .white
		
		self.secondNavController.tabBarItem.title = "Top"
		self.secondNavController.tabBarItem.image = UIImage(systemName: "star")
		self.secondNavController.navigationBar.isHidden = true
		
	}
	
	private func configThirdViewController() {
		self.thirdViewController.view.backgroundColor = .white
		
		self.thirdNavController.tabBarItem.title = "Search"
		self.thirdNavController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
		self.thirdNavController.navigationBar.isHidden = false
	}
	
	private func configFourthViewController() {
		self.fourthViewController.view.backgroundColor = .white
		
		self.fourthNavController.tabBarItem.title = "Favourites"
		self.fourthNavController.tabBarItem.image = UIImage(systemName: "heart")
		self.fourthNavController.navigationBar.isHidden = true
	}
	
}
