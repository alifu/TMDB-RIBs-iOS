//
//  RatioUtils.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 03/10/25.
//

import UIKit

class RatioUtils {
    
    static func aspectRatioOfPoster(withHeight height: CGFloat) -> CGFloat {
        let width = (2 * height) / 3
        return width
    }
    
    static func aspectRatioOfPoster(withWidth width: CGFloat) -> CGFloat {
        let height = (3 * width) / 2
        return height
    }
    
    static func aspectRatioOFBackDrop(withHeight height: CGFloat) -> CGFloat {
        let width = (16 * height) / 9
        return width
    }
    
    static func aspectRatioOFBackDrop(withWidth width: CGFloat) -> CGFloat {
        let height = (9 * width) / 16
        return height
    }
}
