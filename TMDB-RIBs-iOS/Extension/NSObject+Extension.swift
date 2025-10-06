//
//  NSObject+Extension.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import UIKit

extension NSObject {
    
    // MARK: - get UINIB Name
    
    class func theNib() -> UINib  {
        
        let id = String(describing: self)
        let nib = UINib(nibName: id, bundle: nil)
        return nib
    }
    
    // MARK: - get ID Cell
    
    class func idView() -> String {
        
        let id = String(describing: self)
        return id
    }
}
