//
//  NetworkManager.swift
//  NewsBox
//
//  Created by REEMOTTO on 24.01.23.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let apiKey = "f1da7c727eaa478893ae7a6b6b02e26b"
    
    //MARK: - Function to load news data
    
    func loadTopHeadlines(completion: @escaping (NewsAPIStruct?) -> Void) {
        
        let newsUrl = "https://newsapi.org/v2/top-headlines?language=\(Locale.preferredLanguages[0].prefix(2))&apiKey=\(apiKey)"
        
        guard let url = URL(string: newsUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let news = try? JSONDecoder().decode(NewsAPIStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(news)
                }
            }
        }.resume()
    }
    
    //MARK: - Function to load news data from search
    
    func getDataForSearch(with query: String, completion: @escaping (NewsAPIStruct?) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let searchUrlString = "https://newsapi.org/v2/everything?sortBy=relevancy&apiKey=\(apiKey)&q="
        
        let searchString = searchUrlString + query
        
        guard let url = URL(string: searchString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let news = try? JSONDecoder().decode(NewsAPIStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(news)
                }
            }
        }.resume()
        
    }
    
    func loadNewsByCathegory (with category: String, completion: @escaping (NewsAPIStruct?) -> Void) {
        
            let categoryUrlString = "https://newsapi.org/v2/top-headlines?language=\(Locale.preferredLanguages[0].prefix(2))&category=\(category)&apiKey=\(apiKey)"
            
            
            guard let url = URL(string: categoryUrlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let news = try? JSONDecoder().decode(NewsAPIStruct.self, from: data)
                    DispatchQueue.main.async {
                        completion(news)
                    }
                }
            }.resume()
            
        
    }
}
