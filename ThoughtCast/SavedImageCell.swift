//
//  SavedImageCell.swift
//  slate
//
//  Created by Sanira on 7/19/17.
//  Copyright © 2017 ma. All rights reserved.
//

import UIKit

class SavedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    var deselectBoolean = false
    
    override func awakeFromNib() {
        selectedImageView.isHidden = true
        deselect()
    }
    override func prepareForReuse() {
        deselect()
    }
    func setSelection(_ isSelected: Bool) {
        print("set_selection")
        
        if(deselectBoolean)
            {
        selectedImageView.isHidden = false
        }
        else
        {selectedImageView.isHidden = true
            
        }
    }
    func select() {
        super.isSelected = true
        print("does_select")
        selectedImageView.image =  #imageLiteral(resourceName: "selected")
        deselectBoolean = true
    }
    func deselect() {
        super.isSelected = false
        print("dose_deselect")
        selectedImageView.image =  #imageLiteral(resourceName: "not_selected")
        deselectBoolean = true
    }
    
    func invisible()
    {
        self.imageView.image = UIImage.init(named: "reddot")
        
    }
    

    
    func setData(drawing: SavedDrawing) {
        if(drawing.drawingImage.size.width > drawing.drawingImage.size.height)
        {
           drawing.drawingImage =   drawing.drawingImage.rotate(radians: .pi/2)
        }
        self.imageView.image = drawing.drawingImage
        
        if drawing.creationDate == nil
            
        {
            self.dateLabel.text = "TODAY"
        }
        else
        {
            self.dateLabel.text = drawing.creationDate.dateText()
        }
        if drawing.creationDate == nil
        {
            self.timeLabel.text = "TODAY"
        }
        else
        {
            self.timeLabel.text = drawing.creationDate.timeText()
        }
    }
    
    
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
