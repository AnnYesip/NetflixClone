//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 29.08.2022.
//

import UIKit
import SDWebImage

final class HomeScreenPosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeScreenPosterCollectionViewCell"
   
    private let posterImageView: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        poster.layer.cornerRadius = 8
        poster.layer.masksToBounds = true
        return poster
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
//        posterImageView.layer.cornerRadius = 8
//        posterImageView.layer.masksToBounds = true
    }
    
    // MARK: - configureCell
    func configureCell(with model: String) {
        guard let url = URL(
            string: "https://image.tmdb.org/t/p/w500\(model)"
        ) else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)

    }
}
