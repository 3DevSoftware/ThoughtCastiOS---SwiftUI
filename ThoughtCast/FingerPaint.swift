//
//  FingerPaint.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/17/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import Foundation


class FingerPaint: UIImageView
{
    
    var drawColor = UIColor.red    // A color for drawing
    var lineWidth: CGFloat = 25        // A line width
    var first: Bool = true
    private var lastPoint: CGPoint!        // A point for storing the last position
    private var bezierPath: UIBezierPath!    // A bezier path
    private var pointCounter: Int = 0    // A counter of ponts
    private let pointLimit: Int = 128    // A limit of points
    private var preRenderImage: UIImage!    // A pre-render image
    var farPoints: [(point: CGPoint, type: CGPathElementType)] = []
    var outSideFrame: CGSize!
    var iLoad: Bool = false
    var imageToLoad: UIImage!
    var drawn: Bool = false
    var doneClear = false
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(drawColor != UIColor.clear)
        {
            drawn = true
        }
        if(!drawn) { return }
        
        let touch: AnyObject? = touches.first
        lastPoint = touch!.location(in: self)
        pointCounter = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineWidth = 25
        self.isUserInteractionEnabled = true
        if(iLoad)
        {
            self.image = imageToLoad
            first = false
        }
               initBezierPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        lineWidth = 25
        if(iLoad)
        {
            self.image = imageToLoad
            first = false
        }
               initBezierPath()
        self.isUserInteractionEnabled = true
    
    }

    

    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
        
    }
    
    func renderToImage() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
        
        bezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        bezierPath.stroke()
        
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    func initBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineJoinStyle = CGLineJoin.round
    }
    

    func makeImage(with path: UIBezierPath, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawColor.setStroke()
        path.lineWidth = 25
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    

    func doLayer(drawnImage: UIImage) -> UIImage
        
    {
        var bottomImage = self.image
        var topImage = drawnImage
        
        
        if(bottomImage == nil)
        {
            return topImage

        }
        var size = CGSize(width: self.bounds.size.width , height: self.bounds.size.height)
          UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage!.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
   
    
    func drawImage()
    {
        doneClear = false
        
        var savedImage: UIImage!
        var savedDrawnImage: UIImage!

        
        if(first)
        {
            savedImage = UIImage()
            first = false
        }

        else
        {
            savedImage = self.image
        }
        
        savedDrawnImage = makeImage(with: bezierPath, size: self.frame.size)
        
        if(first)
        {
           savedImage = savedDrawnImage
            
        }
        else
        {
            savedImage = doLayer(drawnImage: savedDrawnImage)
            
        }
     
        
       
        image = savedImage
    }
    


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        var newPoint = touch!.location(in: self)
        
        if(drawColor != UIColor.clear)
        {
            drawn = true
        }
        if(!drawn) { return }
        
        
        if(drawColor == UIColor.clear)
        {
            
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            
            image!.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            UIGraphicsGetCurrentContext()!.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()!.addLine(to: CGPoint(x: newPoint.x, y: newPoint.y))
          //  CGContextSetLineCap(UIGraphicsGetCurrentContext()!, CGLineCap.round)
            UIGraphicsGetCurrentContext()!.setLineCap(CGLineCap.round)
            
            UIGraphicsGetCurrentContext()!.setLineWidth(25.0)
            
            
            var components = drawColor.cgColor.components
            
            
            UIGraphicsGetCurrentContext()!.setStrokeColor(UIColor.clear.cgColor)
           UIGraphicsGetCurrentContext()!.setBlendMode(CGBlendMode.clear)
         UIGraphicsGetCurrentContext()!.setShouldAntialias(true)
            UIGraphicsGetCurrentContext()!
                .strokePath()
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            lastPoint = newPoint
      
            UIGraphicsEndImageContext()
            return
        }
  
        bezierPath.move(to: lastPoint)
        farPoints.append((point: lastPoint, type: CGPathElementType.moveToPoint))
        bezierPath.addLine(to: newPoint)
        
        lastPoint = newPoint
    
        pointCounter += 1
        
        
            if pointCounter == pointLimit {
            pointCounter = 0
            renderToImage()
            drawImage()
            bezierPath.removeAllPoints()
        }
        else {
            drawImage()
        }
    }
    
    func clear() {
        preRenderImage = nil
        bezierPath.removeAllPoints()
        
        
//        drawImage()
        self.image = UIImage()
        doneClear = true
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(drawColor != UIColor.clear)
        {
            drawn = true
        }
        if(!drawn) { return }
        
        pointCounter = 0
        renderToImage()
        drawImage()
        bezierPath.removeAllPoints()
    }

    
 
    
    func hasLines() -> Bool {
        return preRenderImage != nil || !bezierPath.isEmpty
    }
    
        
    }
    
  
    
    


extension UIImage {
    
    static func imageByMergingImages(topImage: UIImage, bottomImage: UIImage, scaleForTop: CGFloat = 1.0) -> UIImage {
        let size = bottomImage.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        bottomImage.draw(in: container)
        
        let topWidth = size.width / scaleForTop
        let topHeight = size.height / scaleForTop
        let topX = (size.width / 2.0) - (topWidth / 2.0)
        let topY = (size.height / 2.0) - (topHeight / 2.0)
        
        topImage.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}
