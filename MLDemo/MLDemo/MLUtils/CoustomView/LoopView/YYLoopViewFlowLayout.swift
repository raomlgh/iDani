//
//  YYLoopViewFlowLayout.swift
//  MLDemo
//
//  Created by raoml on 2019/5/17.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

private let kMinScale: CGFloat = 0.618

class YYLoopViewFlowLayout: UICollectionViewFlowLayout {
    
    override var collectionViewContentSize: CGSize {
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)

        let itemsWidth = CGFloat(max(itemCount - 1, 0)) * self.minimumInteritemSpacing + CGFloat(itemCount) * self.itemSize.width

        return CGSize(width: itemsWidth + self.collectionView!.contentInset.left + self.collectionView!.contentInset.right + self.sectionInset.left + self.sectionInset.right, height: self.collectionView!.bounds.height)
    }

    // 对应的单个Item
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        itemAttributes.frame = CGRect(x: self.collectionView!.contentInset.left + self.sectionInset.left + CGFloat(indexPath.item) * (self.itemSize.width + self.minimumInteritemSpacing), y: (self.collectionView!.bounds.height - self.itemSize.height) * 0.5, width: self.itemSize.width, height: self.itemSize.height)
//
//        return itemAttributes
//    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let itemAttributes = super.layoutAttributesForElements(in: rect)!
        // 可见区域
        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        for attri in itemAttributes {
            if visiableRect.intersects(attri.frame) {
                // 可见区域的attributes变化
                let distance = abs(self.collectionView!.contentOffset.x + self.collectionView!.contentInset.left + self.sectionInset.left - attri.frame.minX)
                let scale = kMinScale + (1.0 - distance / (self.collectionView!.bounds.width)) * (1.0 - kMinScale)
                attri.transform = CGAffineTransform(scaleX: 1.0, y: scale)
            }
        }
        return itemAttributes
    }
    
    // 滑动停止时，中间Item显示的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let visibleRect = CGRect(origin: proposedContentOffset, size: self.collectionView!.bounds.size)
        let visibleItemAttributes = self.layoutAttributesForElements(in: visibleRect)!

        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT)
        for attri in visibleItemAttributes {
            if abs(attri.center.x - visibleRect.midX) < abs(adjustOffsetX) {
                adjustOffsetX = attri.center.x - visibleRect.midX;
            }
        }

        return CGPoint(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    }

    // 边界改变就重新布局，默认是false
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
