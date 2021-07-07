//
//  ServiceLayer.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import Foundation

class ServiceLayer<T:Codable>: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
	
	var result: ((T) -> Void)?
	var error: ((Error) -> Void)?
	
	typealias ProgressHandler = (Float) -> ()

	var onProgress : ProgressHandler?
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		let data = try? Data(contentsOf: location)
			let result = self.handleData(T.self, data: data)
			switch result {
			case .success(let success):
				self.result?(success)
			case .failure(let error):
				self.error?(error)
			}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			DispatchQueue.main.async { [weak self] in
				self?.error?(error)
			}
		}
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		let progress = Float(totalBytesWritten) / Float(totalBytesWritten)
		self.onProgress?(progress)
	}
	
	func request(router: Router, page: Int? = nil, query: String? = nil) {
		var components = URLComponents()
		
		components.scheme = router.scheme
		components.host = router.host
		components.path = router.path
		components.queryItems = router.parameters
		if let page = page {
			components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
		}
		if let query = query {
			components.queryItems?.append(URLQueryItem(name: "query", value: query))
		}
		
		guard let url = components.url else {
			self.error?(NetworkError.badURL)
			return
		}
	
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = router.method
		
		let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
		let dataTask = session.downloadTask(with: url)
		dataTask.resume()
			
	}

	private func handleData<T: Codable>(_ type: T.Type, data: Data?) -> Result<T, Error> {
		guard let data = data else { return .failure(NetworkError.noData) }
		
		do {
			let responseObject = try JSONDecoder().decode(type, from: data)
			return .success(responseObject)
			
		} catch {
			return .failure(NetworkError.dataDecodingError)
		}
	}
}
