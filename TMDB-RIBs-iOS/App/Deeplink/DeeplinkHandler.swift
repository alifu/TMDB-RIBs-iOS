//
//  DeeplinkHandler.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 16/10/25.
//

protocol DeeplinkHandler {
    @discardableResult
    func handleDeeplink(_ deeplink: Deeplink) -> Bool
}
