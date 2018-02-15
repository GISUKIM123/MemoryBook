//
//  CustomziedFlowlayout.swift
//  MemoryBook
//
//  Created by gisu kim on 2018-02-03.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

protocol CustomizedLayoutDelegate : class {
    func collectionView(collectionView: UICollectionView, heightForImageAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class CustomizedFlowlayout: UICollectionViewLayout {
    
    var delegate : CustomizedLayoutDelegate?
    
    var numberOfColumns : CGFloat = 3
    var cellPadding : CGFloat = 5.0
    
    private var contentHeight : CGFloat = 0.0
    
    private var contentWidth : CGFloat {
        let insets = collectionView!.contentInset
        
        return ((collectionView?.bounds.width)! - (insets.left + insets.right))
    }
    
    private var attributesCache = [CustomizedLayoutAttributes]()
    
    override func prepare() {
        // clear attributeCache for updates
//        attributesCache = [CustomizedLayoutAttributes]()
        
        let columnWidth = contentWidth / numberOfColumns
        var xOffsets = [CGFloat]()
        for column in 0..<Int(numberOfColumns) {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat] (repeating: 0, count: Int(numberOfColumns))
        
        if attributesCache.isEmpty {
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let width : CGFloat = columnWidth - cellPadding * 2
                let photoHeight : CGFloat = (delegate?.collectionView(collectionView: collectionView!, heightForImageAt: indexPath, with: width))!
                
                let height : CGFloat = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffsets[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // create layout attributes
                let attributes = CustomizedLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.imageHeight = photoHeight
                attributesCache.append(attributes)
                
                // update column and yOffset
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                if column >= (Int(numberOfColumns) - 1) {
                    column = 0
                } else {
                    column += 1
                }
            }
        }else {
            for item in (0..<collectionView!.numberOfItems(inSection: 0)).reversed() {
                let indexPath = IndexPath(item: item, section: 0)
                let width : CGFloat = columnWidth - cellPadding * 2
                let photoHeight : CGFloat = (delegate?.collectionView(collectionView: collectionView!, heightForImageAt: indexPath, with: width))!
                
                let height : CGFloat = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffsets[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // create layout attributes
                let attributes = CustomizedLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.imageHeight = photoHeight
                attributesCache.append(attributes)
                
                // update column and yOffset
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                if column >= (Int(numberOfColumns) - 1) {
                    column = 0
                } else {
                    column += 1
                }
                break
            }
        }
    }
    
    func calculateHeightsForEachImage(item: Int, columnWidth: CGFloat) {
      
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
}

class CustomizedLayoutAttributes : UICollectionViewLayoutAttributes {
    var imageHeight : CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomizedLayoutAttributes
        copy.imageHeight = imageHeight
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CustomizedLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        
        return false
    }
}
