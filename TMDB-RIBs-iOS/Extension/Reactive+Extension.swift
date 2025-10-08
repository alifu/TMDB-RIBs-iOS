//
//  Reactive+Extension.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 07/10/25.
//

import Foundation
import MBProgressHUD
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    var hudVisible: Binder<Bool> {
        return Binder(base) { view, show in
            if show {
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.mode = .indeterminate
                hud.label.text = "Loading..."
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }
}
