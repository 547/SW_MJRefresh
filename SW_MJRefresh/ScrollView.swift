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
    /// mj_header、mj_footer中有一个isRefreshing == true 就返回true
    public var isRefreshing:Bool{
        var result = false
        if let value = mj_header, value.isRefreshing {
            result = true
        }
        if let value = mj_footer, value.isRefreshing {
            result = true
        }
        return result
    }
    /// mj_header的isRefreshing == true 就返回true
    public var headerIsRefreshing:Bool{
        var result = false
        if let value = mj_header, value.isRefreshing {
            result = true
        }
        return result
    }
    /// mj_footer的isRefreshing == true 就返回true
    public var footerIsRefreshing:Bool{
        var result = false
        if let value = mj_footer, value.isRefreshing {
            result = true
        }
        return result
    }
}
extension UIScrollView {
    public func setRefreshView(refreshBlock:(() -> ())?,loadMoreBlock:(() -> ())?) -> (){
        if let refreshBlock = refreshBlock {
            let headView = MJRefreshNormalHeader.init(refreshingBlock: refreshBlock)
            if let lastUpdatedTimeLabel = headView.lastUpdatedTimeLabel{
                lastUpdatedTimeLabel.isHidden = true
            }
            mj_header = headView
        }
        if let loadMoreBlock = loadMoreBlock {
            let footView = MJRefreshAutoNormalFooter.init(refreshingBlock: loadMoreBlock)
            footView.isHidden = true
            mj_footer = footView
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
