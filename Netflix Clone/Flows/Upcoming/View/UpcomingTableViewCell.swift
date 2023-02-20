//
//  UpcomingTableViewCell.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 17.09.2022.
//

import UIKit

final class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    // MARK: - UI
    private let playButton: UIButton = {
        let playButton = UIButton()
        playButton.contentMode = .scaleAspectFill
        let image = UIImage(
            systemName: "play.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
        playButton.setImage(image, for: .normal)
        playButton.tintColor = .whiteColor
        playButton.translatesAutoresizingMaskIntoConstraints = false
        return playButton
    }()
    
    private let posterLabel: UILabel = {
        let posterLabel = UILabel()
        posterLabel.contentMode = .scaleAspectFill
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.textColor = .whiteColor
        posterLabel.numberOfLines = 0
        return posterLabel
    }()
    
    private let posterImageView: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        poster.layer.cornerRadius = 8
        poster.layer.masksToBounds = true
        poster.translatesAutoresizingMaskIntoConstraints = false
        return poster
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setupUI
    private func setupUI() {
        contentView.backgroundColor = .blackBackgroundColor
        contentView.addSubview(posterImageView)
        contentView.addSubview(posterLabel)
        contentView.addSubview(playButton)
        setupPosterImageView()
        setupPosterLabel()
        setupPlayButton()
    }
    
    private func setupPosterImageView() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  5),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -5),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupPosterLabel() {
        NSLayoutConstraint.activate([
            posterLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            posterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupPlayButton() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - configure
    func configure(with model: TitleViewModel) {
        guard let url = URL(
            string: "https://image.tmdb.org/t/p/w500\(model.posterURL)"
        ) else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
        posterLabel.text = model.posterLabel
    }
    
}
