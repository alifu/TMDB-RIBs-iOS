//
//  MovieListsCardCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 03/10/25.
//

import Nuke
import UIKit

final class MovieListsCardCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        super.prepareForReuse()
    }
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private func setupUI() {
        self.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupContent(item: TheMovieLists.Wrapper) {
        
        if let urlString = item.posterPath, let url = URL(string: "\(Natrium.Config.baseImageW500Url)\(urlString)") {
            let request = ImageRequest(url: url)
            ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    self.posterImageView.image = response.image
                case .failure(_):
                    self.posterImageView.image = nil
                }
            }
        }
    }
}
