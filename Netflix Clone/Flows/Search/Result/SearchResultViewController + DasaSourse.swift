//
//  SearchResultViewController + DasaSourse.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 02.10.2022.
//

import UIKit

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.identifier,
            for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let titles = titles[indexPath.row]
        cell.configureCell(with: titles.poster_path ?? " ")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        let model = MovieDetailsModel(
            id: title.id,
            title: titleName,
            titleOverView: title.overview ?? " "
        )
        // не работает. сделать позде через делегвт 
        coordinator?.showMovieDetailViewController(viewModel: MovieDetailsViewModel(), model: model)
    }
    
}
