//
//  AlertService.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

class AlertService {
	class func alertWithAction(title: String? = nil, message: String, handler: ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let action = UIAlertAction(title: "OK", style: .default) { _ in handler }
		let cancel = UIAlertAction(title: "Отмена", style: .cancel)
	
		alert.addAction(action)
		alert.addAction(cancel)
		
		return alert
	}
	
	class func alert(message: String) -> UIAlertController {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		
		let action = UIAlertAction(title: "OK", style: .cancel)
	
		alert.addAction(action)
		
		return alert
	}
	
}
