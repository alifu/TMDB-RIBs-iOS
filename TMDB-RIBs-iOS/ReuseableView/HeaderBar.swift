//
//  HeaderBar.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 01/10/25.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class HeaderBar: UIView {
    
    var leftTap: ControlEvent<Void> {
        leftButton.rx.tap
    }
    
    var rightTap: ControlEvent<Void> {
        rightButton.rx.tap
    }
    
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
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = ColorUtils.white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private func setupUI() {
        self.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(leftButton)
        containerView.addSubview(rightButton)
        
        containerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.centerX.equalTo(containerView.snp.centerX)
        }
    }
    
    func setupContent(titleText: String, leftImage: UIImage? = nil, rightImage: UIImage? = nil) {
        titleLabel.text = titleText
        leftButton.isHidden = leftImage == nil
        rightButton.isHidden = rightImage == nil
        leftButton.setImage(leftImage, for: .normal)
        rightButton.setImage(rightImage, for: .normal)
    }
}
