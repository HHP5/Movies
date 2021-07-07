//
//  SearchViewController.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

class SearchViewController: UIViewController {
	
	var viewModel: PopularTopSearchViewModelType!
	
	private let searchController = UISearchController(searchResultsController: nil)
	private let screenView = CollectionView()
	private var isLoadMore: Int = 0
	
	init(viewModel: PopularTopSearchViewModelType) {
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel = viewModel
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupSearchController()
		self.setupView()
		
	}
	
	private func setupSearchController() {
		self.searchController.searchBar.delegate = self
		self.navigationItem.searchController = searchController
		
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.searchController.searchBar.placeholder = "Search for places"
		self.searchController.searchBar.backgroundColor = .clear
		self.searchController.searchBar.tintColor = .black
	}
	
	private func setupView() {
		self.view.addSubview(screenView)
		
		screenView.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.left.right.bottom.equalToSuperview()
		}
		screenView.hideProgressBar()
		
		screenView.collectionView?.delegate = self
		screenView.collectionView?.dataSource = self
	}
	
	private func bind() {
		viewModel.didFinishRequest = { [weak self] in
			DispatchQueue.main.async {
				self?.screenView.stopActivityIndicator()
			}
		}
		
		viewModel.didUpdateData = { [weak self] in
			DispatchQueue.main.async {
				self?.screenView.collectionView?.reloadData()
			}
		}
		
		viewModel.didFoundError = { [weak self] alert in
			self?.present(alert, animated: true, completion: nil)
		}
	}
	
	private func loadMovies() {
		
		DispatchQueue.main.async {
			if self.isLoadMore != 0 {
				self.viewModel.loadMore()
			}
		}
	}
	
}


extension SearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.find(searchBar:)), object: searchBar)
		perform(#selector(self.find(searchBar:)), with: searchBar, afterDelay: 0.5)
	}
	
	
	@objc func find(searchBar: UISearchBar) {
		
		if let text = searchBar.text {
			if text != "" && text != " " {
				self.viewModel.search(text)
				self.bind()
			} else {
				self.screenView.startActivityIndicator()
				self.viewModel.clear()
			}
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.screenView.startActivityIndicator()
		self.viewModel.clear()
	}
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
}

