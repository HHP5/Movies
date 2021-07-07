//
//  FavouritesViewController.swift
//  Movies
//
//  Created by Екатерина Григорьева on 06.07.2021.
//

import UIKit

class FavouritesViewController: UIViewController {
	var viewModel: FavouritesViewModelType!
	
	private let screenView = CollectionView()
	
	init(viewModel: FavouritesViewModelType) {
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.getMovies()
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		self.screenView.startActivityIndicator()
	}
	
	private func getMovies() {
		self.viewModel.getMovies {
			self.screenView.stopActivityIndicator()
			self.screenView.collectionView?.reloadData()
		}
	}
	
	private func setupView() {
		self.view.addSubview(screenView)
		
		screenView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		self.screenView.collectionView?.delegate = self
		self.screenView.collectionView?.dataSource = self
		
		self.screenView.hideProgressBar()
	}
	
	private func bind() {
		
		self.screenView.stopActivityIndicator()
		self.screenView.collectionView?.reloadData()
	}
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfRow ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
		cell.poster.kf.setImage(with: viewModel.image[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.width / 2.0 - 20, height: 200.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let action: () = viewModel.removeFromFavourite(movie: self.viewModel.image[indexPath.row]) {
			self.getMovies()
		}

		let alert = AlertService.alertWithAction(message: "Remove from favourites", handler: action)
		self.present(alert, animated: true, completion: nil)
	}
}
