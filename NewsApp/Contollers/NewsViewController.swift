//
//  ViewController.swift
//  NewsApp
//
//  Created by Zeynep Özdemir Açıkgöz on 4.01.2023.
//

import UIKit
import SafariServices // haber içeriiklerini almak için

class NewsViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NEWS"
        spinner.startAnimating()
        
        self.tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifier)
        fetchTopStories()
        createSearchBar()
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    // apı doğrulama
    private func fetchTopStories(){
    APICaller.shared.getTopStories { [weak self] result in
        switch result{
        case.success(let articles):
            self?.articles = articles
            self?.viewModels  = articles.compactMap({ viewModels in
                NewsTableViewCellModel(title: viewModels .title ?? "", subtitle: viewModels.description ?? "", imageUrl: URL(string: viewModels.urlToImage ?? ""))
            })
            
            DispatchQueue.main.async {
                 self?.tableView.reloadData()
             }
        case.failure(let error):
            print(error)
        }
    }
    }
}

extension NewsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else{ return }
        print(text)
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result{
            case.success(let articles):
                self?.articles = articles
                self?.viewModels  = articles.compactMap({ viewModels in
                    NewsTableViewCellModel(title: viewModels .title ?? "", subtitle: viewModels.description ?? "", imageUrl: URL(string: viewModels.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case.failure(let error):
                print(error)
            }
        }
        
        
    }}
//tableView protocols

extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        spinner.stopAnimating()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else{
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    
}



