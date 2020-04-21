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
    struct AssociatedKey {
        static var isRefreshingKey_UIScrollView = "20002000"
    }
}
extension UIScrollView {
    ///正在加载数据
     var is_refreshing_datas: Bool {
         set {
             objc_setAssociatedObject(self, &AssociatedKey.isRefreshingKey_UIScrollView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
         }
         
         get {
             if let rs = objc_getAssociatedObject(self, &AssociatedKey.isRefreshingKey_UIScrollView) as? Bool {
                 return rs
             }
             
             return true
         }
     }
}
public extension UIScrollView {
    ///正在加载数据
    var isRefreshingDatas:Bool {
        return is_refreshing_datas
    }
}
public extension UIScrollView {
    /// 更新isRefreshingDatas = true, completed为空时自动reloadData(), 并且hidden mj_footer(ScrollView == UITableView|UICollectionView才reloadData，否则只更新isRefreshingDatas的值)，不为空时则执行completed
    /// - Parameters:
    ///   - completed: 更新isRefreshingDatas的值后要执行的
    func refreshingDatas(_ completed:(() -> ())? = nil) -> () {
        is_refreshing_datas = true
        if let ct = completed{
           ct()
        }else {
            if let tb = self as? UITableView {
                tb.reloadData()
            }else if let cv = self as? UICollectionView {
                cv.reloadData()
            }
            if let value = mj_footer, !value.isHidden {
                footerView(hidden: true)
            }
        }
    }
    /// 更新isRefreshingDatas = false
    /// - Parameters:
    ///   - completed: 更新isRefreshingDatas的值后要执行的
    func endRefreshingDatas(_ completed:(() -> ())? = nil) -> () {
        is_refreshing_datas = false
        if let ct = completed{
           ct()
        }
    }
}
public extension UIScrollView {
    /// mj_header的isRefreshing == true 就返回true
    var headerIsRefreshing:Bool{
        var result = false
        if let value = mj_header, value.isRefreshing {
            result = true
        }
        return result
    }
    /// mj_footer的isRefreshing == true 就返回true
    var footerIsLoadingMore:Bool{
        var result = false
        if let value = mj_footer, value.isRefreshing {
            result = true
        }
        return result
    }
}
public extension UIScrollView {
    func setRefreshView(refreshBlock:(() -> ())?,loadMoreBlock:(() -> ())?) -> (){
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
    func headerView(hidden:Bool) -> () {
        if let mj_header = mj_header, mj_header.isHidden != hidden {
            mj_header.isHidden = hidden
        }
    }
    func footerView(hidden:Bool) -> () {
        if let mj_footer = mj_footer, mj_footer.isHidden != hidden {
            mj_footer.isHidden = hidden
        }
    }
    func stopRefresh() -> () {
        if let mj_footer = mj_footer, mj_footer.isRefreshing {
            mj_footer.endRefreshing()
        }
        if let mj_header = mj_header, mj_header.isRefreshing {
            mj_header.endRefreshing()
        }
    }
    func refresh() -> () {
        if let mj_header = mj_header {
            mj_header.beginRefreshing()
        }
    }
}
