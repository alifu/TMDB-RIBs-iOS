//
//  UIScreen+Extension.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 07/10/25.
//

import UIKit

extension UIScreen {
    static var safeWidth: CGFloat {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.screen.bounds.width
        }
        return UIScreen.main.bounds.width
    }
}
