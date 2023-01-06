//
//  NewsModel.swift
//  NewsApp
//
//  Created by Zeynep Özdemir Açıkgöz on 4.01.2023.
//

import Foundation



struct NewsAPIResponse: Codable{
    
    let results: [APIResponse]
    
}


// MARK: - Welcome
struct APIResponse: Codable {
    
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    var source: Source?
    var author: String?
    var title:String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}

// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String?
}



//https://newsapi.org/v2/everything?q=Apple&from=2023-01-04&sortBy=popularity&apiKey=b9f8c2da40f546798937458fabdf9ad5
