//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit
import ColorKit

final class HeroHeaderUIView: UIView {
    private var  heroImageViewDominantColor: [UIColor] = [.whiteColor]
    
    // MARK: - init UI
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let homeViewPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor.cgColor
        imageView.layer.borderWidth = 0.2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let playButton: UIButton = {
       let button = UIButton()
        button.setTitle(" Play", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .blackBackgroundColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .whiteColor.withAlphaComponent(0.8)
        button.setTitleColor(.blackBackgroundColor, for: .normal)
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle(" Download", for: .normal)
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.tintColor = .blackBackgroundColor
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .whiteColor.withAlphaComponent(0.8)
        button.setTitleColor(.blackBackgroundColor, for: .normal)
        button.layer.cornerRadius = 3
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
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeViewPosterImageView.layer.cornerRadius = 16
        homeViewPosterImageView.layer.masksToBounds = true
    }
    
    
    // MARK: - Constraints
    private func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        contentView.addSubview(homeViewPosterImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
    }
    
    private func setupHeroImageViewConstraints() {
        NSLayoutConstraint.activate([
            homeViewPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            homeViewPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            homeViewPosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            homeViewPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    private func setupPlayButtonConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: homeViewPosterImageView.leadingAnchor, constant: 40),
            playButton.bottomAnchor.constraint(equalTo: homeViewPosterImageView.bottomAnchor, constant:  -5),
            playButton.widthAnchor.constraint(equalTo: homeViewPosterImageView.widthAnchor, multiplier: 0.35),
            playButton.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
    
    private func setupDownloadButtonConstraints() {
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: homeViewPosterImageView.trailingAnchor, constant: -40),
            downloadButton.bottomAnchor.constraint(equalTo: homeViewPosterImageView.bottomAnchor, constant:  -5),
            downloadButton.widthAnchor.constraint(equalTo: homeViewPosterImageView.widthAnchor, multiplier: 0.35),
            downloadButton.heightAnchor.constraint(equalTo: playButton.heightAnchor)
        ])
    }
    // MARK: - Config gradient
    private func addGradient(complition: @escaping (Result<UIColor, Error>) -> Void) {
        do {
            guard let image = homeViewPosterImageView.image else { return }
            heroImageViewDominantColor = try image.dominantColors()
        } catch {
            print("no dominantColors")
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            heroImageViewDominantColor.first?.cgColor,
            heroImageViewDominantColor[1].cgColor,
            heroImageViewDominantColor[2].cgColor,
            UIColor.blackBackgroundColor.cgColor
        ]
        
        gradientLayer.frame = bounds
        gradientLayer.zPosition = -1
        contentView.layer.addSublayer(gradientLayer)
        
        complition(.success(heroImageViewDominantColor.first!))
    
    }
    
    // MARK: - Config view
    
    func configure(with model: TitleViewModel, complition: @escaping (Result<UIColor, Error>) -> Void) {
        guard let url = URL(
            string: "https://image.tmdb.org/t/p/w500\(model.posterURL)"
        ) else { return }
        
        homeViewPosterImageView.sd_setImage(with: url) { [weak self] (image, error, cach, url) in
            self?.addGradient { result in
                switch result {
                case .success(let success):
                    complition(.success(success))
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        
        
    }
    
}

