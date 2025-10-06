//
//  PopularMovieCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import Nuke
import SnapKit
import UIKit

final class PopularMovieCell: UICollectionViewCell {
    
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 90, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    private func setupUI() {
        self.addSubview(posterImageView)
        self.addSubview(numberLabel)
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-16)
        }
    }
    
    func setupContent(indexPath: IndexPath, item: TheMoviePopular.Result) {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: ColorUtils.blue,
            .foregroundColor: ColorUtils.darkBlue,
            .strokeWidth: -1.0,
            .font: UIFont.systemFont(ofSize: 90, weight: .bold)
        ]
        let textWithStroke = NSAttributedString(string: "\(indexPath.item + 1)", attributes: attributes)
        numberLabel.attributedText = textWithStroke
        
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
