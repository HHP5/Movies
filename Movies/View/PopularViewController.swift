//
//  ViewController.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit
import SnapKit
import Kingfisher

class PopularViewController: UIViewController {
	let refresh = UIRefreshControl()
	private let screenView = CollectionView()
	var viewModel: PopularTopSearchViewModelType!
	var isLoadMore: Int = 0
	
	init(viewModel: PopularTopSearchViewModelType) {
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupView()
		self.loadMovies()
		
	}
	
	private func loadMovies() {
		self.screenView.progressBar.progress = 0
		self.screenView.showProgressBar()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			if self.isLoadMore != 0 {
				self.viewModel.loadMore()
			}
			self.viewModel.fetching()
			self.bind()
		}
		
	}
	
	private func setupView() {
		self.view.addSubview(screenView)
		
		screenView.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
		}
		
		self.screenView.collectionView?.delegate = self
		self.screenView.collectionView?.dataSource = self
		
		refresh.attributedTitle = NSAttributedString(string: "Идет обновление...")
		refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
		screenView.collectionView!.addSubview(refresh)
	}
	
	@objc private func refreshCollectionView() {
		self.viewModel.refresh()
		DispatchQueue.main.async {
			self.screenView.collectionView?.reloadData()
			self.refresh.endRefreshing()
		}
	}
	
	private func bind() {
		viewModel.didFinishRequest = { [weak self] in
			DispatchQueue.main.async {
				self?.screenView.stopActivityIndicator()
				self?.screenView.hideProgressBar()
			}
		}
		
		viewModel.didUpdateData = { [weak self] in
			DispatchQueue.main.async {
				self?.screenView.collectionView?.reloadData()
			}
		}
		
		viewModel.onProgress = { [weak self] progress in
			self?.screenView.progressBar.progress = progress
		}
		
		viewModel.didFoundError = { [weak self] alert in
			self?.present(alert, animated: true, completion: nil)
		}
	}
}

extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		let deltaOffset = maximumOffset - currentOffset
		
		if deltaOffset <= 0 {
			if self.isLoadMore < 1000 {
				self.isLoadMore += 1
				self.loadMovies()
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let action: () = viewModel.saveNewFavouriteMovie(movie: self.viewModel.image[indexPath.row]) { [weak self] alert in
			self?.present(alert, animated: true, completion: nil)
		}

		let alert = AlertService.alertWithAction(message: "Add to favourites", handler: action)
		self.present(alert, animated: true, completion: nil)
	}
}
