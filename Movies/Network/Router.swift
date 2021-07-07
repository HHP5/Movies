//
//  Router.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import Foundation

enum Router {
	
	case top
	case popular
	case search
	
	var scheme: String {
		switch self {
		case .top, .popular, .search:
			return "https"
		}
	}
	
	var host: String {
		switch self {
		case .top, .popular, .search:
			return "api.themoviedb.org"
		}
	}
	
	var path: String {
		switch self {
		case .top:
			return "/3/movie/top_rated"
		case .popular:
			return "/3/movie/popular"
		case .search:
			return "/3/search/movie"
		}
	}
	
	var method: String {
		switch self {
		case .top, .popular, .search:
			return "GET"
		}
	}
	
	var parameters: [URLQueryItem] {
		
		switch self {
		
		case .popular, .top, .search:
			return [URLQueryItem(name: "api_key", value: APIKey.key)]
		}
	}
	
}
