//
//  NewsArticle+CoreDataProperties.swift
//  NewsBox
//
//  Created by REEMOTTO on 16.02.23.
//
//

import Foundation
import CoreData


extension NewsArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var url: String?

}

extension NewsArticle : Identifiable {

}
