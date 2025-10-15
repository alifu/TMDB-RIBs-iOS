//
//  MovieCarouselCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import Nuke
import SnapKit
import UIKit

final class MovieCarouselCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backdropView: UIView = {
        let view = UIView()
        view.alpha = 0.5
        view.backgroundColor = .black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = CGSize(width: 0, height: 1)
        return titleLabel
    }()
    
    private let playIcon: UIImageView = {
        let image = UIImage(systemName: "play.circle.fill")
        let playIcon = UIImageView()
        playIcon.tintColor = .white
        playIcon.contentMode = .scaleToFill
        playIcon.image = image
        playIcon.backgroundColor = .black.withAlphaComponent(0.5)
        playIcon.layer.cornerRadius = 24
        return playIcon
    }()
    
    private var currentTaskBackDrop: ImageTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(backdropView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playIcon)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        playIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(132)
            $0.right.bottom.equalToSuperview().inset(12)
        }
        backdropView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.top).offset(-12)
        }
    }
    
    func configure(with item: TheMovieCaraousel) {
        currentTaskBackDrop?.cancel()
        if let url = item.imageURL {
            let request = ImageRequest(url: url)
            imageView.image = nil
            currentTaskBackDrop = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    UIView.transition(
                        with: self.imageView,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.imageView.image = response.image
                        }
                    )
                case .failure(_):
                    self.imageView.image = nil
                }
            }
        }
        
        switch item {
        case .backdrop:
            titleLabel.text = nil
            playIcon.isHidden = true
            backdropView.isHidden = true
        case .video(let video):
            titleLabel.text = video.name
            playIcon.isHidden = false
            backdropView.isHidden = false
        }
    }
}
