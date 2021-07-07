//
//  PopularResponse.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import Foundation

// MARK: - Popular
struct APIResponse: Codable {
	let results: [Movie]
}

// MARK: - Result
struct Movie: Codable, Equatable {
	let originalTitle: String
	let posterPath: String?
	
	enum CodingKeys: String, CodingKey {
		case originalTitle = "original_title"
		case posterPath = "poster_path"
	}
}




