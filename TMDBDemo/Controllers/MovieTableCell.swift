//
//  MovieTableCell.swift
//  TMDBDemo
//
//  Created by Captain on 4/15/19.
//  Copyright © 2019 Captain. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MovieTableCell: UITableViewCell {
    
    let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w92/")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .byWordWrapping
        self.detailTextLabel?.numberOfLines = 0
        self.detailTextLabel?.lineBreakMode = .byWordWrapping
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ movie: Movie)
    {
        textLabel?.text = "\(movie.title) \n(\(movie.poster_path))"
        detailTextLabel?.text = movie.overview
        //imageView?.kf.setImage(with: baseImageURL?.appendingPathComponent(movie.poster_path))
        //imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //imageView?.sd_setImage(with: baseImageURL?.appendingPathComponent(movie.poster_path))
        
    }
    
}
