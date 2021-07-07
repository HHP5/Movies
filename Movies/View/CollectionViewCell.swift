//
//  CollectionViewCell.swift
//  Movies
//
//  Created by Екатерина Григорьева on 03.07.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
	static let identifier = "collectionCell"
	
	let poster = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure(){
		self.backgroundColor = .white
		
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.black.cgColor
		
		self.layer.cornerRadius = 20
		self.clipsToBounds = true
		
		self.addSubview(poster)
		
		poster.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		poster.kf.indicatorType = .activity
	}
}
