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
                view.viewWithTag(overlayTag)?.subviews.forEach { $0.removeFromSuperview() }
                view.viewWithTag(overlayTag)?.removeFromSuperview()
            }
        }
    }
    
    var errorView: Binder<ErrorViewModel?> {
        return Binder(base) { view, model in
            let tag = 999_777 // unique tag for error view
            
            if let model = model {
                // already visible?
                if view.viewWithTag(tag) == nil {
                    let errorView = ErrorView()
                    errorView.configure(image: model.image,
                                        title: model.title,
                                        subtitle: model.subtitle)
                    errorView.tag = tag
                    errorView.alpha = 0
                    
                    view.addSubview(errorView)
                    errorView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.lessThanOrEqualTo(view).multipliedBy(0.9)
                    }
                    
                    UIView.animate(withDuration: 0.1) {
                        errorView.alpha = 1
                    }
                } else if let errorView = view.viewWithTag(tag) as? ErrorView {
                    // update existing
                    errorView.configure(image: model.image,
                                        title: model.title,
                                        subtitle: model.subtitle)
                }
            } else {
                // remove existing with fade
                if let errorView = view.viewWithTag(tag) {
                    UIView.animate(withDuration: 0, animations: {
                        errorView.alpha = 0
                    }) { _ in
                        errorView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
