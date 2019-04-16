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
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster_pathLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w154/")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(_ movie: Movie)
    {
        overviewLabel.text = movie.overview
        titleLabel.text = movie.title
        if let image_path = movie.poster_path
        {
            posterImage.kf.indicatorType = .activity
            poster_pathLabel.text = image_path
            posterImage.kf.setImage(with: baseImageURL?.appendingPathComponent(image_path))
        }
    }
    
    override func prepareForReuse() {
        posterImage.image = nil
        titleLabel.text = nil
        poster_pathLabel.text = nil
        overviewLabel.text = nil
    }
    
}
