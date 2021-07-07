//
//  CoreDataManager.swift
//  Movies
//
//  Created by Екатерина Григорьева on 06.07.2021.
//

import UIKit
import CoreData

class CoreDataManager {
	
	var favoriteMovies = [FavoriteMovies]()
	var movieArray: [Movie] = []
	let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
	
	func loadFavoriteMovies(with request: NSFetchRequest<FavoriteMovies> = FavoriteMovies.fetchRequest()) -> [Movie] {
		
		do {
			favoriteMovies = try container.viewContext.fetch(request)
		} catch {
			print("Error fetching categories \(error)")
		}
		var array: [Movie] = []
		favoriteMovies.forEach { movie in
			if let title = movie.title {
				array.append(Movie(originalTitle: title, posterPath: movie.posterPath))
			}
		}
		return array
	}
	
	func delete(at index: Int, completion: @escaping () -> Void) {
		let movie = favoriteMovies[index]
		self.favoriteMovies.remove(at: index)
		self.container.viewContext.delete(movie)
		
		try? self.container.viewContext.save()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { completion() })
	}
	
	func saveFavoriteMovie(movie: Movie, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			
			if !self.movieArray.contains(movie) {
				self.movieArray.append(movie)
				
				let newMovie = FavoriteMovies(context: context)
				newMovie.title = movie.originalTitle
				newMovie.posterPath = movie.posterPath
				
				self.favoriteMovies.append(newMovie)
				
				try? context.save()
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {completion() })
			}
		}
	}
	
}
