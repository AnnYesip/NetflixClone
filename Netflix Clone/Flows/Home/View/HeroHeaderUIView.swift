//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

final class HeroHeaderUIView: UIView {
    
    // MARK: - init UI
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let playButton: UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        
        setupContentView()
        setupHeroImageViewConstraints()
        setupPlayButtonConstraints()
        setupDownloadButtonConstraints()
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Constraints
    private func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        contentView.addSubview(heroImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
    }
    
    private func setupHeroImageViewConstraints() {
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }
    
    private func setupPlayButtonConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant:  -50),
            playButton.widthAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupDownloadButtonConstraints() {
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant:  -50),
            downloadButton.widthAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    // MARK: - Config gradient
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.blackBackgroundColor.cgColor
        ]
        gradientLayer.frame = bounds
        heroImageView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Config view
    
    func configure(with model: TitleViewModel) {
        guard let url = URL(
            string: "https://image.tmdb.org/t/p/w500\(model.posterURL)"
        ) else { return }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
}
