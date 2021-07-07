//
//  NetworkError.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import Foundation

enum NetworkError: String, Error {
	
	case none
	case badURL = "Invalid URL"
	case clientError = "Client Error"
	case noData = "Response returned with no data to decode"
	case dataDecodingError = "Error decoding response"
	case redirection = "Redirection"
	case serverError = "Server Error"
}

extension NetworkError: LocalizedError {
	var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
