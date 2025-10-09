//
//  MovieCardCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import Nuke
import SnapKit
import UIKit

final class MovieCardCell: UITableViewCell {
    
    private var currentTask: ImageTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.currentTask?.cancel()
        self.posterImageView.image = nil
        super.prepareForReuse()
    }
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let releaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "calendar")
        return imageView
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private func setupUI() {
        [posterImageView, titleLabel, releaseImageView, releaseLabel].forEach { item in
            self.contentView.addSubview(item)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(RatioUtils.aspectRatioOfPoster(withHeight: 120))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        releaseImageView.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(8)
            $0.width.height.equalTo(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        releaseLabel.snp.makeConstraints {
            $0.leading.equalTo(releaseImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(releaseImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupContent(with movie: TheMovieSearchMovie.Result) {
        loadImage(path: movie.posterPath)
        titleLabel.text = movie.title
        releaseLabel.text = movie.releaseYear
    }
    
    func setupContent(with movie: TheMovieWatchList.Result) {
        loadImage(path: movie.posterPath)
        titleLabel.text = movie.title
        releaseLabel.text = movie.releaseYear
    }
    
    private func loadImage(path: String?) {
        currentTask?.cancel()
        
        if let urlString = path, let url = URL(string: "\(Natrium.Config.baseImageW500Url)\(urlString)") {
            let request = ImageRequest(url: url)
            posterImageView.image = nil
            currentTask = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    UIView.transition(
                        with: self.posterImageView,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.posterImageView.image = response.image
                        }
                    )
                case .failure:
                    self.posterImageView.image = nil
                }
            }
        }
    }
}
