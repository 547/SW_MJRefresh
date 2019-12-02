//
//  ScrollView.swift
//  SW_MJRefresh
//
//  Created by Supernova SanDick SSD on 2019/6/19.
//  Copyright © 2019 Seven. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
extension UIScrollView {
    public func setRefreshView(refreshBlock:(() -> ())?,loadMoreBlock:(() -> ())?) -> (){
        if let refreshBlock = refreshBlock {
            let headView = MJRefreshNormalHeader.init(refreshingBlock: refreshBlock)
            headView.lastUpdatedTimeLabel?.isHidden = true
            mj_header = headView
        }
        if let loadMoreBlock = loadMoreBlock {
            let footView = MJRefreshAutoNormalFooter.init(refreshingBlock: loadMoreBlock)
            mj_footer = footView
            mj_footer?.isHidden = true
        }
    }
    public func headerView(hidden:Bool) -> () {
        if let mj_header = mj_header, mj_header.isHidden != hidden {
            mj_header.isHidden = hidden
        }
    }
    public func footerView(hidden:Bool) -> () {
        if let mj_footer = mj_footer, mj_footer.isHidden != hidden {
            mj_footer.isHidden = hidden
        }
    }
    public func stopRefresh() -> () {
        if let mj_footer = mj_footer, mj_footer.isRefreshing {
            mj_footer.endRefreshing()
        }
        if let mj_header = mj_header, mj_header.isRefreshing {
            mj_header.endRefreshing()
        }
    }
    public func refresh() -> () {
        if let mj_header = mj_header {
            mj_header.beginRefreshing()
        }
    }
}
