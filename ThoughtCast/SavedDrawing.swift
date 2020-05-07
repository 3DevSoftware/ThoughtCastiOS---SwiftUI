//
//  SavedDrawing.swift
//  slate
//
//  Created by Sanira on 7/19/17.
//  Copyright © 2017 ma. All rights reserved.
//

import Foundation
import Photos

class SavedDrawing {
    var drawingImage: UIImage!
    var creationDate: Date!
    var asset: PHAsset!
    var isSelected = false
 
    init(image: UIImage, date: Date, asset: PHAsset) {
        self.asset = asset
        self.drawingImage = image
        self.creationDate = date
        
    }
    init(image: UIImage) {
        
    //    self.drawingImage = image
        
    }
}

class SavedDrawings {
    var collection: [SavedDrawing] = []
    init() { }
    
    var allAssets: [PHAsset] {
        return collection.map {$0.asset}
    }
    
    var selectedAssets: [PHAsset] {
        return selectedDrawings.map {$0.asset}
    }
    
    var selectedImages: [UIImage] {
        get {
            return selectedDrawings.map {$0.drawingImage}
        }
    }
    var selectedDrawings: [SavedDrawing] {
        get {
            guard collection.count > 0 else {
                return []
            }
            
            var selectedDrawings = [SavedDrawing]()
            for i in collection {
                if i.isSelected{
                    selectedDrawings.append(i)
                }
            }
            return selectedDrawings
        }
    }
    func deleselectAllDrawings() {
        for d in selectedDrawings {
            d.isSelected = false
        }
    }
}
