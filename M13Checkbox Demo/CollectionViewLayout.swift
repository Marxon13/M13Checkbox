//
//  CollectionViewLayout.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/9/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    
    //----------------------------
    // MARK: - Initalize
    //----------------------------
    
    override init() {
        super.init()
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    fileprivate func sharedSetup() {
        scrollDirection = .horizontal
        minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Update the collection view insets.
        var insets = UIEdgeInsets.zero
        if scrollDirection == .horizontal {
            if let leftCellSize = layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.bounds.size {
                insets.left = (collectionView.bounds.size.width - leftCellSize.width) / 2.0
            }
            
            let section = collectionView.numberOfSections - 1
            let item = collectionView.numberOfItems(inSection: section) - 1
            if let rightCellSize = layoutAttributesForItem(at: IndexPath(item: item, section: section))?.bounds.size {
                insets.right = (collectionView.bounds.size.width - rightCellSize.width) / 2.0
            }
        } else {
            if let topCellSize = layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.bounds.size {
                insets.top = (collectionView.bounds.size.height - topCellSize.height) / 2.0
            }
            
            let section = collectionView.numberOfSections - 1
            let item = collectionView.numberOfItems(inSection: section) - 1
            if let bottomCellSize = layoutAttributesForItem(at: IndexPath(item: item, section: section))?.bounds.size {
                insets.bottom = (collectionView.bounds.size.height - bottomCellSize.height) / 2.0
            }
        }
        collectionView.contentInset = insets
        
        minimumLineSpacing = 100.0
        
        
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    } 
    
    //----------------------------
    // MARK: - Paging
    //----------------------------
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let collectionView = collectionView {
            
            let bounds = collectionView.bounds
            let center = collectionView.bounds.size.width / 2.0
            var proposedContentOffsetCenter: CGFloat = 0.0
            if scrollDirection == .horizontal {
                proposedContentOffsetCenter = proposedContentOffset.x + center
            } else {
                proposedContentOffsetCenter = proposedContentOffset.y + center
            }
            
            if let candidateAttributes = layoutAttributesForElements(in: bounds)?.filter({ $0.representedElementCategory == .cell }) {
                var candidate: UICollectionViewLayoutAttributes?
                
                for attributes in candidateAttributes {
                    if let previousCandidate = candidate {
                        var a: CGFloat = 0.0
                        var b: CGFloat = 0.0
                        if scrollDirection == .horizontal {
                            a = attributes.center.x - proposedContentOffsetCenter
                            b = previousCandidate.center.x - proposedContentOffsetCenter
                        } else {
                            a = attributes.center.y - proposedContentOffsetCenter
                            b = previousCandidate.center.y - proposedContentOffsetCenter
                        }
                        
                        if abs(a) < abs(b) {
                            candidate = attributes
                        }
                    } else {
                        candidate = attributes
                    }
                }
                
                if scrollDirection == .horizontal {
                    print("Target X: ", round(candidate!.center.x - center))
                    return CGPoint(x: round(candidate!.center.x - center), y: proposedContentOffset.y)
                } else {
                    return CGPoint(x: proposedContentOffset.x, y: round(candidate!.center.x - center))
                }
            }
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
    
}
