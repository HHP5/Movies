//
//  PopularViewModel.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

protocol PopularTopSearchViewModelType {
	
	typealias ProgressHandler = (Float) -> ()
	var onProgress : ProgressHandler? {get set}
	var numberOfRow: Int? {get set}
	var image: [URL] {get set}
	var didUpdateData: (() -> Void)? {get set}
	var didFinishRequest: (() -> Void)? {get set}
	func fetching()
	func loadMore()
	func refresh()
	var didFoundError: ((UIAlertController) -> Void)? {get set}
	
	func search(_ query: String)
	func clear()
	func saveNewFavouriteMovie(movie posterURL: URL, completion: @escaping (UIAlertController) -> Void)
}

class PopularTopSearchViewModel: PopularTopSearchViewModelType {
	
	var movies: [Movie] = []
	var didUpdateData: (() -> Void)?
	var didFinishRequest: (() -> Void)?
	var image: [URL] = []
	var type: ViewModelType!
	var currentPage = 1
	var didFoundError: ((UIAlertController) -> Void)?
	var query: String?
	
	typealias ProgressHandler = (Float) -> ()
	
	var onProgress : ProgressHandler?
	
	private var coreDataManager = CoreDataManager()
	
	init(type: ViewModelType) {
		self.type = type
	}
	
	func loadMore() {
		self.currentPage += 1
		fetching()
	}
	
	func refresh() {
		self.movies = []
		self.currentPage = 1
		self.fetching()
	}
	
	func fetching() {
		
		var router: Router!
		switch type {
		case .popular:
			router = Router.popular
		case .top:
			router = Router.top
		case .search:
			router = Router.search
		default:
			return
		}
		
		let model = ServiceLayer<APIResponse>()
		model.request(router: router, page: self.currentPage, query: self.query)
		
		model.result = { [weak self] result in
			self?.handle(result: result.results)
			self?.didFinishRequest?()
		}
		
		model.error = { [weak self] error in
			let alert = AlertService.alert(message: error.localizedDescription)
			self?.didFoundError?(alert)
		}
		
		model.onProgress = { [weak self] progress in
			self?.onProgress?(progress)
		}
		
	}
	
	var numberOfRow: Int?
	
	func handle(result: [Movie]) {
		result.forEach { movie in
			if !movies.contains(movie) {
				self.movies.append(movie)
				if let poster =  movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/" + poster) {
					image.append(url)
				} else {
					if let url = NoImage.url {
						image.append(url)
					}
				}
				
			}
		}
		self.numberOfRow = movies.count
		self.didUpdateData?()
	}
	
	
	func search(_ query: String) {
		self.refreshArray()
		self.query = query
		self.fetching()
	}
	
	func clear() {
		self.refreshArray()
	}
	
	private func refreshArray() {
		self.numberOfRow = 0
		self.image = []
		self.movies = []
	}
	
	func saveNewFavouriteMovie(movie posterURL: URL, completion: @escaping (UIAlertController) -> Void ) {
		let favMovies = coreDataManager.loadFavoriteMovies()
		
		self.movies.forEach { movie in
			if posterURL.absoluteString != NoImage.url?.absoluteString {
				if posterURL.absoluteString.contains(movie.posterPath!) {
					if !favMovies.contains(movie) {
						coreDataManager.saveFavoriteMovie(movie: movie) {
							let alert = AlertService.alert(message: "Saved")
							completion(alert)
						}
					} else {
						let alert = AlertService.alert(message: "Already in favourites")
						completion(alert)
					}
				}
			}
		}
	}
	
}
