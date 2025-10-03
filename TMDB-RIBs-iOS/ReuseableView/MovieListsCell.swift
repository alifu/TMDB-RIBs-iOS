//
//  MovieListsCell.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import SnapKit
import UIKit

final class MovieListsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.mediumDarkBlue
        return view
    }()
    
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(divider)
        
        divider.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(divider.snp.top)
        }
    }
    
    func setupContent(_ item: TheMovieLists.Tab) {
        titleLabel.text = item.title
        divider.isHidden = !item.isSelected
    }
}
