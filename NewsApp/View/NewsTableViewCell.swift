//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Zeynep Özdemir Açıkgöz on 4.01.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSubtitleLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
   
   public func configure(with viewModel : NewsTableViewCellModel){
        
       newsTitleLabel.text  = viewModel.title
        newsSubtitleLabel.text = viewModel.subtitle
       //image cornerRadius verildi
       newsImageView.layer.cornerRadius = newsImageView.frame.height / 9

        
        //image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageUrl {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                // data = viewModel.imageData
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

}
