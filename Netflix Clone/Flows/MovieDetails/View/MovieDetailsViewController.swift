//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 02.10.2022.
//

import UIKit
import WebKit

final class MovieDetailsViewController: UIViewController {
    
    private var viewModel: MovieDetailsViewModelProtocol = MovieDetailsViewModel()
    
    weak var coordinator: TabCoordinator?
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let noResultPicture: UIImageView = {
        let noResult = UIImageView()
        noResult.contentMode = .scaleAspectFill
        let imageNumber = [1,2,3].randomElement()
        noResult.image = UIImage(named: "noResult" + "\(imageNumber ?? 1)")
        noResult.translatesAutoresizingMaskIntoConstraints = false
        noResult.isHidden = true
        noResult.alpha = 0.7
        return noResult
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Info not found"
        label.textAlignment = .center
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let genre = UILabel()
        genre.textColor = .darkGreyColor
        genre.font = .systemFont(ofSize: 15, weight: .semibold)
        genre.translatesAutoresizingMaskIntoConstraints = false
        genre.numberOfLines = 0
        return genre
    }()
    
    private let imdbImage: UIImageView = {
        let imdb = UIImageView()
        imdb.contentMode = .scaleAspectFill
        imdb.image = UIImage(named: "imdbLogo")
        imdb.translatesAutoresizingMaskIntoConstraints = false
        return imdb
    }()
    
    private let ratingLabel: UILabel = {
        let rating = UILabel()
        rating.textColor = .whiteColor
        rating.font = .systemFont(ofSize: 16, weight: .bold)
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
        let download = UIButton()
        download.backgroundColor = .systemRed
        download.setTitle("Download", for: .normal)
        download.setTitleColor(.white, for: .normal)
        download.layer.cornerRadius = 8
        download.layer.masksToBounds = true
        download.translatesAutoresizingMaskIntoConstraints = false
        return download
    }()
    
    // MARK: - init
    init(viewModel: MovieDetailsViewModel, model: MovieDetailsModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        fetchMovieBy(id: model.id)
        fetchMovieTrailer(movie: model.title)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .blackBackgroundColor
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - UI setup
    private func setupUI() {
        view.addSubview(contentView)
        
        setupContentView()
        setupWebView()
        setupNoResultPicture()
        setupNoResultLabel()
        setupTitleLabel()
        setupGenreLabel()
        setupIMDBImage()
        setupRatingLabel()
        setupOverviewLabel()
        setupDownloadButton()
    }
    
    // MARK: - fetchData
    
    private func fetchMovieBy(id: Int) {
        viewModel.fetchMovieDetails(id: id) { [weak self] movieDetails in
            switch movieDetails {
            case .success(let details):
                self?.setupUI(with: details)
            case .failure(let error):
                self?.movieDetailNotFound()
                print(error)
            }
            
        }
    }
    
    private func fetchMovieTrailer(movie: String) {
        viewModel.searchTrailer(movie: movie) { [weak self] result in
            switch result {
            case .success(let trailer):
                DispatchQueue.main.async {
                    self?.webView.load(URLRequest(url: trailer))
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    private func movieDetailNotFound() {
        DispatchQueue.main.async {
            self.noResultPicture.isHidden = false
            self.noResultLabel.isHidden = false
            self.titleLabel.isHidden = true
            self.genreLabel.isHidden = true
            self.imdbImage.isHidden = true
            self.ratingLabel.isHidden = true
            self.overviewLabel.isHidden = true
            self.downloadButton.isHidden = true
        }
    }

    // MARK: - setupUI
    private func setupUI(with movie: MovieDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
            self.ratingLabel.text = "\(Float(movie.voteAverage))"
            self.genreLabel.text = viewModel.findGenre(movie: movie)
            
        }
    }
    
    
    // MARK: - setup constraints
    
    private func setupContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        contentView.addSubview(webView)
        contentView.addSubview(noResultPicture)
        contentView.addSubview(noResultLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(imdbImage)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(downloadButton)
    }
    
    private func setupWebView() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupNoResultPicture() {
        NSLayoutConstraint.activate([
            noResultPicture.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            noResultPicture.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noResultPicture.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            noResultPicture.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupNoResultLabel() {
        NSLayoutConstraint.activate([
            noResultLabel.topAnchor.constraint(equalTo: noResultPicture.bottomAnchor, constant: 10),
            noResultLabel.centerXAnchor.constraint(equalTo: noResultPicture.centerXAnchor),
            noResultLabel.widthAnchor.constraint(equalTo: noResultPicture.widthAnchor, multiplier: 0.9),
            noResultLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.08)
            
        ])
    }
    
    private func setupTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
            
        ])
    }
    
    private func setupGenreLabel() {
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func setupIMDBImage() {
        NSLayoutConstraint.activate([
            imdbImage.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
            imdbImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imdbImage.widthAnchor.constraint(equalToConstant: 20),
            imdbImage.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    private func setupRatingLabel() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: imdbImage.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: imdbImage.leadingAnchor, constant: 30)
            
        ])
    }
    
    private func setupOverviewLabel() {
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 15),
            overviewLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            overviewLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
            
        ])
    }
    
    private func setupDownloadButton() {
        NSLayoutConstraint.activate([
            downloadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 15),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
            
        ])
    }
    
    //MARK: - deinited
    deinit {
        print("\(self) deinited")
    }
    
}
