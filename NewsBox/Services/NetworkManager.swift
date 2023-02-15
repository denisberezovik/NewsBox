//
//  NetworkManager.swift
//  NewsBox
//
//  Created by REEMOTTO on 24.01.23.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let apiKey = "0d51d68a82fc48ad8c8f9b850dd3d55e"
    
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
        
        let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=\(apiKey)&q="
        
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
    
    //MARK: - Function to load news data by cathegory
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
    
    //MARK: - Function to get page news data
    
    func getPageData(page: Int, completion: @escaping (NewsAPIStruct?) -> Void) {
        let newsUrl = "https://newsapi.org/v2/top-headlines?page=\(page)&pageSize=10&language=\(Locale.preferredLanguages[0].prefix(2))&apiKey=\(apiKey)"
        
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
}
