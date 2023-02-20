//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 14.08.2022.
//

import UIKit

protocol CollectionViewTableViewCellProtocol: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: MovieDetailsModel)
}

final class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellProtocol?
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            TitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .blackBackgroundColor
        return collectionView
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - configure
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - downloadMovie
    private func downloadMovieAt(indexPath: IndexPath) {
        
        let movieModel = titles[indexPath.row]
        //TODO: make viewModel
        CoreDataManager.shared.downloadMovie(with: movieModel) { result in
            switch result {
            case .success(let success):
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("download \(movieModel.original_title) is success !! ")
            case .failure(let failure):
                print("on no, something is wrong :( ")
            }
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.identifier,
            for: indexPath
        ) as? TitleCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
            
        }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
            
        }
        cell.configureCell(with: model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
 
        guard let overView = title.overview else { return }
        let model = MovieDetailsModel(
            id: title.id,
            title: titleName,
            titleOverView: overView
        )
        self.delegate?.collectionViewTableViewCellDidTapCell(
            self,
            model: model
        )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration =  UIContextMenuConfiguration(actionProvider:  { [weak self] _ in
            let downloadAction = UIAction(title: "Download", state: .off) { _ in
                self?.downloadMovieAt(indexPath: indexPaths.first!)
            }
            return UIMenu(children: [downloadAction])
        })
        return configuration
    }
    
}

