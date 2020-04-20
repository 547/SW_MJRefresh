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
var isRefreshingKey_UIScrollView = "isRefreshingKey_UIScrollView"
extension UIScrollView {
    ///正在加载数据
    public var isRefreshingDatas:Bool {
        return is_refreshing_datas
    }
   ///正在加载数据
   private var is_refreshing_datas: Bool {
        set {
            objc_setAssociatedObject(self, &isRefreshingKey_UIScrollView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &isRefreshingKey_UIScrollView) as? Bool {
                return rs
            }
            return false
        }
    }
}
extension UIScrollView {
    /// 更新是否在刷新数据, completed为空时自动reloadData(), 并且hidden mj_footer(ScrollView == UITableView|UICollectionView才reloadData，否则只更新isRefreshingDatas的值)，不为空时则执行completed
    /// - Parameters:
    ///   - value: 是否在刷新数据
    ///   - completed: 更新isRefreshingDatas的值后要执行的
    public func isRefreshingDatas(_ value:Bool, completed:(() -> ())? = nil) -> () {
        is_refreshing_datas = value
        if let ct = completed{
           ct()
        }else {
            if let tb = self as? UITableView {
                tb.reloadData()
            }else if let cv = self as? UICollectionView {
                cv.reloadData()
            }
            if value, let value = mj_footer, !value.isHidden {
                footerView(hidden: true)
            }
        }
    }
}
extension UIScrollView {
    /// mj_header的isRefreshing == true 就返回true
    public var headerIsRefreshing:Bool{
        var result = false
        if let value = mj_header, value.isRefreshing {
            result = true
        }
        return result
    }
    /// mj_footer的isRefreshing == true 就返回true
    public var footerIsLoadingMore:Bool{
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
