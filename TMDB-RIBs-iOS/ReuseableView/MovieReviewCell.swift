//
//  MovieReviewCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 09/10/25.
//

import Nuke
import SnapKit
import UIKit

final class MovieReviewCell: UITableViewCell {
    
    private var currentTask: ImageTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        currentTask?.cancel()
        avatarImageView.image = nil
        super.prepareForReuse()
    }
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = ColorUtils.blue
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private func setupUI() {
        [avatarImageView, ratingLabel, nameLabel, reviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(14)
            $0.centerX.equalTo(avatarImageView.snp.centerX)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setupContent(with item: TheMovieReview.Result) {
        
        ratingLabel.text = "\(item.authorDetails.rating ?? 0)"
        nameLabel.text = item.author
        reviewLabel.text = item.content
        
        if let urlString = item.authorDetails.avatarPath, let url = URL(string: "\(Natrium.Config.baseImageW500Url)\(urlString)") {
            let request = ImageRequest(url: url)
            avatarImageView.image = nil
            currentTask = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    UIView.transition(
                        with: self.avatarImageView,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.avatarImageView.image = response.image
                        }
                    )
                case .failure(_):
                    self.avatarImageView.image = nil
                }
            }
        }
    }
}
