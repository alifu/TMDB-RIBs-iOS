//
//  MiniTab.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import Foundation
import RxDataSources

extension TheMovieLists.Tab: IdentifiableType, Equatable {
    public var identity: Int { id }
    
    static func == (lhs: TheMovieLists.Tab, rhs: TheMovieLists.Tab) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.isSelected == rhs.isSelected &&
        lhs.type == rhs.type
    }
}

extension TheMovieDetailInfo.Tab: IdentifiableType, Equatable {
    public var identity: Int { id }
    
    static func == (lhs: TheMovieDetailInfo.Tab, rhs: TheMovieDetailInfo.Tab) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.isSelected == rhs.isSelected &&
        lhs.type == rhs.type
    }
}

enum MiniTab: IdentifiableType, Equatable {
    case movieList(TheMovieLists.Tab)
    case movieDetail(TheMovieDetailInfo.Tab)
    
    var identity: String {
        switch self {
        case .movieList:
            return "movieList"
        case .movieDetail:
            return "movieDetail"
        }
    }
    
    static func == (lhs: MiniTab, rhs: MiniTab) -> Bool {
        switch (lhs, rhs) {
        case (.movieList(let lTabs), .movieList(let rTabs)):
            return lTabs == rTabs
        case (.movieDetail(let lTabs), .movieDetail(let rTabs)):
            return lTabs == rTabs
        default:
            return false
        }
    }
    
    func toggled(selectedId id: Int) -> MiniTab {
        switch self {
        case .movieList(var tab):
            tab.isSelected = (tab.id == id)
            return .movieList(tab)
        case .movieDetail(var tab):
            tab.isSelected = (tab.id == id)
            return .movieDetail(tab)
        }
    }
}

struct SectionOfMiniTab {
    let context: Context
    var items: [MiniTab]
    
    enum Context: String {
        case movieList
        case movieDetail
        
        var identity: String { rawValue + "-section" }
    }
}

extension SectionOfMiniTab: AnimatableSectionModelType {
    typealias Item = MiniTab
    
    // MARK: - AnimatableSectionModelType
    var identity: String {
        context.identity
    }
    
    init(original: SectionOfMiniTab, items: [MiniTab]) {
        self.context = original.context
        self.items = items
    }
}

extension SectionOfMiniTab: Equatable {
    static func == (lhs: SectionOfMiniTab, rhs: SectionOfMiniTab) -> Bool {
        lhs.context == rhs.context && lhs.items == rhs.items
    }
}

extension Array where Element == MiniTab {
    var detectedContext: SectionOfMiniTab.Context {
        guard let first = first else { return .movieList }
        switch first {
        case .movieList: return .movieList
        case .movieDetail: return .movieDetail
        }
    }
}

extension Array where Element == MiniTab {
    func selecting(id: Int) -> [MiniTab] {
        self.map { $0.toggled(selectedId: id) }
    }
}

