//
//  CollectionView.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

class CollectionView: UIView {

	var collectionView: UICollectionView?
	var progressBar = UIProgressView()
	
	private let activityIndicator = UIActivityIndicatorView(style: .large)

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.set()
		self.setActivityIndicator()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	 func set() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 60, height: 60)
		
		collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
		collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
		
		setupProgressBar()

		self.addSubview(collectionView!)
		collectionView?.snp.makeConstraints{ make in
			make.right.left.bottom.equalToSuperview()
			make.top.equalTo(progressBar.snp.bottom)
		}
		self.collectionView?.isUserInteractionEnabled = true
		self.collectionView?.backgroundColor = .white
		
	
	}
	
	func hideProgressBar() {
		self.progressBar.isHidden = true
	}
	
	func showProgressBar() {
		self.progressBar.isHidden = false
	}
	
	private func setupProgressBar() {
		self.addSubview(progressBar)
		
		progressBar.snp.makeConstraints { make in
			make.top.right.left.equalToSuperview()
			make.height.equalTo(10)
		}
		
		progressBar.progressTintColor = .purple
		progressBar.progress = 1
	}
	
	 func setActivityIndicator() {
		self.backgroundColor = .white
		self.addSubview(activityIndicator)
		
		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		startActivityIndicator()
	}
	
	 func startActivityIndicator() {
		collectionView?.isHidden = true
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}
	
	func stopActivityIndicator() {

		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
		
		collectionView?.isHidden = false

	}
	
}
