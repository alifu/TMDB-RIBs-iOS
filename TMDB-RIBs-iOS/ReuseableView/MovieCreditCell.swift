//
//  MovieCreditCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import Nuke
import SnapKit
import UIKit

final class MovieCreditCell: UICollectionViewCell {
    
    private var currentTask: ImageTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        currentTask?.cancel()
        castImageView.image = nil
        super.prepareForReuse()
    }
    
    private let castImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private func setupUI() {
        self.addSubview(castImageView)
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        castImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }
    }
    
    func setupContent(with data: TheMovieCredit.Cast, radius: CGFloat) {
        nameLabel.text = data.name
        castImageView.layer.cornerRadius = radius
        
        currentTask?.cancel()
        
        if let urlString = data.profilePath, let url = URL(string: "\(Natrium.Config.baseImageW500Url)\(urlString)") {
            let request = ImageRequest(url: url)
            castImageView.image = nil
            currentTask = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    UIView.transition(
                        with: self.castImageView,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.castImageView.image = response.image
                        }
                    )
                case .failure:
                    self.castImageView.image = nil
                }
            }
        }
    }
}
