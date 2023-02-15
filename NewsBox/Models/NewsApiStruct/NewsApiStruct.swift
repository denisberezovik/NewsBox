//
//  NewsApiStruct.swift
//  NewsBox
//
//  Created by REEMOTTO on 11.01.23.
//

import UIKit

// MARK: - NewsAPIStruct

struct NewsAPIStruct: Decodable {
    let status: String?
    let totalResults: Int?
    var articles: [Article]?
}

// MARK: - Article

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case articleDescription = "description"
        case url
        case urlToImage
        case content
    }
}

// MARK: - Source
struct Source: Decodable {
    let id: String?
    let name: String?
}
