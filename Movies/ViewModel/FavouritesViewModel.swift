//
//  FavouritesViewModel.swift
//  Movies
//
//  Created by Екатерина Григорьева on 06.07.2021.
//

import UIKit

protocol FavouritesViewModelType {
	var numberOfRow: Int? {get set}
	var image: [URL] {get set}
	
	func getMovies(completion: @escaping () -> Void)
	func removeFromFavourite(movie posterURL: URL, completion: @escaping () -> Void)
}

class FavouritesViewModel: FavouritesViewModelType {
	var image: [URL] = []
	var numberOfRow: Int?
	private var movies: [Movie] = []
	private let coreDataManager = CoreDataManager()
	
	func getMovies(completion: @escaping () -> Void) {
		self.movies = self.coreDataManager.loadFavoriteMovies()
		self.handle {
			completion()
		}
	}
	
	private func handle(completion: @escaping () -> Void) {
		self.movies.forEach { movie in
			if let poster =  movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500/" + poster) {
				if !image.contains(url) {
					self.image.append(url)
				}
			} else {
				if let url = NoImage.url {
					self.image.append(url)
				}
			}
		}
		self.numberOfRow = self.movies.count
		completion()
	}
	
	func removeFromFavourite(movie posterURL: URL, completion: @escaping () -> Void) {
		
		for i in 0...image.count-1 {
			if posterURL == image[i] {
				self.coreDataManager.delete(at: i) {
					self.image.remove(at: i)

					completion()
				}
			}
		}
	}
}
