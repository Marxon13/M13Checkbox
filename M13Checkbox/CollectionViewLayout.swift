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
    
    private func sharedSetup() {
        scrollDirection = .Horizontal
        minimumInteritemSpacing = CGFloat.max
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let collectionView = collectionView else { return }
        
        // Update the collection view insets.
        var insets = UIEdgeInsetsZero
        if scrollDirection == .Horizontal {
            if let leftCellSize = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))?.bounds.size {
                insets.left = (collectionView.bounds.size.width - leftCellSize.width) / 2.0
            }
            
            let section = collectionView.numberOfSections() - 1
            let item = collectionView.numberOfItemsInSection(section) - 1
            if let rightCellSize = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: item, inSection: section))?.bounds.size {
                insets.right = (collectionView.bounds.size.width - rightCellSize.width) / 2.0
            }
        } else {
            if let topCellSize = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))?.bounds.size {
                insets.top = (collectionView.bounds.size.height - topCellSize.height) / 2.0
            }
            
            let section = collectionView.numberOfSections() - 1
            let item = collectionView.numberOfItemsInSection(section) - 1
            if let bottomCellSize = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: item, inSection: section))?.bounds.size {
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
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let collectionView = collectionView {
            
            let bounds = collectionView.bounds
            let center = collectionView.bounds.size.width / 2.0
            var proposedContentOffsetCenter: CGFloat = 0.0
            if scrollDirection == .Horizontal {
                proposedContentOffsetCenter = proposedContentOffset.x + center
            } else {
                proposedContentOffsetCenter = proposedContentOffset.y + center
            }
            
            if let candidateAttributes = layoutAttributesForElementsInRect(bounds)?.filter({ $0.representedElementCategory == .Cell }) {
                var candidate: UICollectionViewLayoutAttributes?
                
                for attributes in candidateAttributes {
                    if let previousCandidate = candidate {
                        var a: CGFloat = 0.0
                        var b: CGFloat = 0.0
                        if scrollDirection == .Horizontal {
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
                
                if scrollDirection == .Horizontal {
                    print("Target X: ", round(candidate!.center.x - center))
                    return CGPoint(x: round(candidate!.center.x - center), y: proposedContentOffset.y)
                } else {
                    return CGPoint(x: proposedContentOffset.x, y: round(candidate!.center.x - center))
                }
            }
        }
        
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
    }
    
}
