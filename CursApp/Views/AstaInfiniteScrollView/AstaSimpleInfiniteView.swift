//
//  AstaSimpleInfiniteScrollView.swift
//  Demo
//
//  Created by lailiang on 2019/8/20.
//  Copyright © 2019 lailiang. All rights reserved.
//

import UIKit

class AstaSimpleInfiniteView: AstaInfiniteScrollView, AstaInfiniteScrollViewDelegate {
    
    var dataModels: [Any]?
    
    func renderItem(_ renderItem: @escaping (Int, Any, UICollectionViewCell) -> Void) {
        self.renderItem = renderItem
    }
    
    func didTapItem(_ didTapItem: @escaping (Int, Any) -> Void) {
        self.didTapItem = didTapItem
    }
    
    private var renderItem: ((Int, Any, UICollectionViewCell) -> Void)?
    
    private var didTapItem: ((Int, Any) -> Void)?
    
    private(set) var cellType: CellType
    
    override var delegate: AstaInfiniteScrollViewDelegate? {
        set {}
        get { return self }
    }
    
    init(frame: CGRect, cellType: CellType) {
        self.cellType = cellType
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // AstaInfiniteScrollViewDelegate
    func numberOfItems(in infiniteScrollView: AstaInfiniteScrollView) -> Int {
        return dataModels?.count ?? 0
    }
    
    func infiniteScrollView(_ infiniteScrollView: AstaInfiniteScrollView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = infiniteScrollView.dequeueReusableCell(withType: cellType, for: indexPath)
        if let renderItem = self.renderItem {
            let index = infiniteScrollView.index(for: indexPath)
            renderItem(index, dataModels![index], cell)
        }
        return cell
    }
    
    func infiniteScrollView(_ infiniteScrollView: AstaInfiniteScrollView, didSelectedItemAt indexPath: IndexPath) {
        if let didTapItem = self.didTapItem {
            let index = infiniteScrollView.index(for: indexPath)
            didTapItem(index, dataModels![index])
        }
    }
    
}
