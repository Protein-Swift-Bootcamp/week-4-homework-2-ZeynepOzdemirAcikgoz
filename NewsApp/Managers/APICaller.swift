//
//  APICaller.swift
//  NewsApp
//
//  Created by Zeynep Özdemir Açıkgöz on 4.01.2023.
//

import Foundation


struct Constants{
    
    static let API_KEY = "b9f8c2da40f546798937458fabdf9ad5"
    static let baseURL = "https://newsapi.org"
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=b9f8c2da40f546798937458fabdf9ad5")
    static let searchURL = URL(string: "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=b9f8c2da40f546798937458fabdf9ad5&q=")
    
}

class APICaller{
    
    static let shared = APICaller()
    
    private init(){}
        
        //topHeadlinesURL query
         public func getTopStories(completion: @escaping (Result<[Article], Error >)-> Void){
            guard let url = Constants.topHeadlinesURL else{ return }
             
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                if let error = error{
                    completion(.failure(error))
                }
                else if let data = data{
                    do{
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        
                        print("Articles: \(String(describing: result.articles?.count))")
                        completion(.success(result.articles!))
                    }catch{
                        
                        completion(.failure(error))
                    }
                    
                }
            }
             task.resume()
        }
        
    //query search
    public func search(with query:String,completion: @escaping (Result<[Article], Error >)-> Void){
       //tüm boşlukları kırparak sorgunun boş olmadığını doğruluyoruz
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/v2/everything?sortBy=popularity&apiKey=\(Constants.API_KEY)&q=\(query)") else {
            return
        }
       /* let urlString = String(Constants.searchURL) + (query)
        guard let url = URL(string: urlString) else{ return }*/
        
       let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
           if let error = error{
               completion(.failure(error))
           }
           else if let data = data{
               do{
                   let result = try JSONDecoder().decode(APIResponse.self, from: data)
                   
                   print("Articles: \(String(describing: result.articles?.count))")
                   completion(.success(result.articles!))
               }catch{
                   
                   completion(.failure(error))
               }
               
           }
       }
        task.resume()
   }
    
    
}
