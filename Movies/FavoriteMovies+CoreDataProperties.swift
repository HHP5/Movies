//
//  FavoriteMovies+CoreDataProperties.swift
//  
//
//  Created by Екатерина Григорьева on 06.07.2021.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?

}
