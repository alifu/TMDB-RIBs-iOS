//
//  Reactive+Extension.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 07/10/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

extension Reactive where Base: UIView {
    var loaderVisible: Binder<Bool> {
        return Binder(base) { view, show in
            let overlayTag = 999_999
            let indicatorTag = 999_998
            
            if show {
                // Prevent duplicate overlays
                guard view.viewWithTag(overlayTag) == nil else { return }
                
                // Create overlay container
                let overlay: UIView = {
                    let view = UIView()
                    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                    view.layer.cornerRadius = 12
                    view.clipsToBounds = true
                    view.tag = overlayTag
                    return view
                }()
                
                // Create activity indicator
                let indicator: UIActivityIndicatorView = {
                    let indicator = UIActivityIndicatorView(style: .large)
                    indicator.color = .white
                    indicator.startAnimating()
                    indicator.tag = indicatorTag
                    return indicator
                }()
                
                // Add subviews
                view.addSubview(overlay)
                overlay.addSubview(indicator)
                
                // Layout with SnapKit
                overlay.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.height.equalTo(100)
                }
                
                indicator.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            } else {
                // Remove overlay and indicator
                view.viewWithTag(overlayTag)?.removeFromSuperview()
                view.viewWithTag(indicatorTag)?.removeFromSuperview()
            }
        }
    }
}
