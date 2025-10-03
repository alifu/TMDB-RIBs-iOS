//
//  SearchBox.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 01/10/25.
//

import SnapKit
import UIKit

final class SearchBox: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = ColorUtils.mediumDarkBlue
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = ColorUtils.grey
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search"))
        return imageView
    }()
    
    private func setupUI() {
        self.addSubview(containerView)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(searchImageView)
        containerView.addSubview(placeholderLabel)
        
        containerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        searchImageView.snp.makeConstraints {
            $0.height.width.equalTo(16)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-12)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(12)
            $0.centerY.equalTo(containerView.snp.centerY)
        }
    }
}
