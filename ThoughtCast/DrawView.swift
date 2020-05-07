//
//  DrawingModeView.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/7/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
//import WatchKit
import WatchConnectivity

class DrawView: UIView
{

    var portraitToSave: [(point: CGPoint, type: CGPathElementType)] = []
    
    var portraitToSavePath = UIBezierPath()
    var lastColor = 10
    var Updating = false
    var doingUpdate = false
    var watchMode = false
    var INMOVE = false
    var watchBounds: CGRect!
    var inZoneMode = false
    var lastZone = 0
    var lines: [Line] = []
    var rotateBounds: CGRect!
    var lastPoint: CGPoint!
    var path = UIBezierPath()
    var watchPath = UIBezierPath()
    var currentLayer = CAShapeLayer()
    var savedPath = UIBezierPath()
    var farPath = UIBezierPath()
    var farWatchPath = UIBezierPath()
    var adjusted = false
    var degreesOfRotation: CGFloat!
var isBackground = false
    var isMainDraw = false
    
    var tSize: CGSize!
    var drawn = false
    var lineCount = 0
    var started = false
    var changed = false
    var incognito: Bool!
    var cleared = false
    
    var Watchchanged = false
    var test: CGRect!
    var timer = Timer()
    
    var currentPage = DRAWING_MODE
    var imageToSend: UIImage!
    
    var currentColor = UIColor.white
    
    var currentZone = 0
    var pathSet: Bool!
    
   
    
    func updateWatch(NewPoints newpoints: [(point: CGPoint, type: CGPathElementType)], newBounds: CGRect! = nil)
        
    {
        watchPath = UIBezierPath()
        
        Watchchanged = true
        
        //  print("some error chek: \(tSize.height) + \(tSize.width) ------> \(self.frame.height) + \(self.frame.width)")
        // print("test: \(newpoints.count)")
        
        
        
        
        for i in 0 ..< newpoints.count {
            switch (newpoints[i].type.rawValue)
            {
            case 0:
                
                
                watchPath.move(to: convert_point_watch(point: newpoints[i].point))
       
                
                
                break
                
            case 1:
                
              
                watchPath.addLine(to: convert_point_watch(point: newpoints[i].point))
                break
            case 2:
                break
            default:
                break
            }
        }
        
        sendWatchMessage()
        Watchchanged = false
        print("DONE WITH THE REDRAW")
    }
    

    
    func DEGREESTORADIANS(_ degrees: CGFloat) -> CGFloat
    {
        
        
        return ((.pi * degrees)/180.0)
    }
    
  
    func stop()
    {
        timer.invalidate()
    }

  
    func updateDot()
    {
        changed = true
        print("should switch back.")
        sendWatchMessage()
    }



    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat) -> UIImage {
        
        
        
        
        let newWidth =   image.size.width < posX +   image.size.width ? posX +   image.size.width :   image.size.width
        let newHeight =   image.size.height < posY +  image.size.height ? posY +   image.size.height :   image.size.height
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size:   image.size))
        image.draw(in: CGRect(origin: CGPoint(x: posX, y: posY), size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func drawImagesAndText(imageToAdd: UIImage) -> UIImage{
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // 3
            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            
            // 4
            let string = "Thy"
            string.draw(with: CGRect(x:0, y: 0, width: 50, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
            // 5
            let mouse = imageToAdd
            mouse.draw(at: CGPoint(x: 0, y: 0))
        }
        
        // 6
            return img
    }
    
    
    
    
    func imageWith(name: String?, color: UIColor) -> UIImage? {
        let text = name as! String
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.backgroundColor: UIColor.black.withAlphaComponent(0.6),
              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let textSize = text.size(withAttributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
        let rect = CGRect(origin: .zero, size: textSize)
        
        
        text.draw(with: rect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func testing() -> UIImage!
    {
        
        
        let image: UIImage? =
            "Test".image(withAttributes: [.font: UIFont.systemFont(ofSize: 11.0),],
                         size: CGSize(width: 150.0, height: 50.0))
        
        return image!
    }
    
    @objc
    func sendWatchMessage() {
        print("***** send to watch 01 ********")
        
        if(MyManager.shared()?.currentPage == DRAWING_MODE || MyManager.shared().currentPage == ZONE_GO)
        {
        let currentTime = CFAbsoluteTimeGetCurrent()
        lineCount = 0
        var XappDelegate = AppDelegate()
      DispatchQueue.main.async {
         XappDelegate = UIApplication.shared.delegate as! AppDelegate
        if(XappDelegate.watchBounds == nil) { XappDelegate.requestBounds() }
        else { self.watchBounds = XappDelegate.watchBounds}
        }
        

        
        
        print("testing watchbounds: \(watchBounds)")
          if(!INMOVE) { return }
        if (watchPath == nil && Watchchanged == false) {return }
        
        if (Watchchanged == false) { return }
        
        Watchchanged = false
 
          print("-> \(currentPage) :: \(MyManager.shared().currentPage)<-")
        if(!UserDefaults.standard.bool( forKey: "Watchmode"))
        {
            
            
            if(watchBounds == nil) { return }
            print("\(watchBounds) <- watch bounds test.")
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: watchBounds.width, height: watchBounds.height))
            let img = renderer.image { ctx in
                ctx.cgContext.setFillColor(UIColor.black.cgColor)
                ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                ctx.cgContext.setLineWidth(10)
                
                let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                ctx.cgContext.addRect(rectangle)
                ctx.cgContext.drawPath(using: .fillStroke)
            }
            
            var superImage  = UIImage(named: "WatchX") as! UIImage
           
            print("***** send to watch 02 ********")

            
            
            var imageToSend = img.overlayWith(image: superImage, posX: 0, posY: watchBounds.height - 45)
                    if(currentPage != MyManager.shared().currentPage) { return }
            
            XappDelegate.sendMessage(msgToSend: imageToSend)
       
            print("***** send to watch 03 ********")

            print("an attempt at sending too watch.")
            return
        }
        
        // send a message to the watch if it's reachable
      
        print("at this point...")
        
      
     
        if(watchBounds == nil)
        {
        
            print("NIL!!!")
            return
        }
        print("made it.")
   
        if (WCSession.default.isReachable) {
       
            
            var img = UIImage()
            var imageToSend = UIImage()
            var farImageToSend = UIImage()
            if(!cleared)
            {
                
            
                var pathR = UIBezierPath()
                
                pathR = UIBezierPath.init(cgPath: watchPath.cgPath)
                
                var pathNew = UIBezierPath()
                
                pathNew = UIBezierPath.init(cgPath: pathR.cgPath)
                pathNew = pathNew.fit(into: watchBounds).moveCenter(to: watchBounds.center)
                farWatchPath = UIBezierPath()
                
                
                farWatchPath = UIBezierPath.init(cgPath: pathNew.cgPath)
                
                
                
                
                print("sending watch image")
                
                let rendererX = UIGraphicsImageRenderer(size: CGSize(width: watchBounds.width, height: watchBounds.height))
                 var imgBLACK = rendererX.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                    
                 
            }
                
                imageToSend = imageToSend.overlayWith(image: imgBLACK, posX: 0, posY: 0)
                imageToSend = imageToSend.overlayWith(image: makeImageWatch(with: farWatchPath, size: watchBounds.size ) as! UIImage, posX: 0, posY: 0)
                farImageToSend = imageToSend
            }
            else
            {
      
                
                
                
             
                
                
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: watchBounds.width, height: watchBounds.height))
                img = renderer.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
                
              
               
            }
            
            
         
            
          var label = UIImage()
            
            var XsuperColor = UIColor.white
            
            let renderera = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
            let imgtwo = renderera.image { ctx in
                
                print("Setting dot color.")
                if(MyManager.shared().batteryCharge > 20 && !MyManager.shared().isCharging)
                {
                    ctx.cgContext.setFillColor(UIColor.green.cgColor)
                    XsuperColor = UIColor.green
                    print("drew a green dot.")
                    
                   label = imageWith(name: "\(MyManager.shared().batteryCharge)%", color: XsuperColor) as! UIImage
                    
                }
                else if(MyManager.shared().isCharging || MyManager.shared().batteryCharge < 20)
                {
                    ctx.cgContext.setFillColor(UIColor.orange.cgColor)
                    XsuperColor = UIColor.orange
                    print("drew an orange dot.")
                    label = imageWith(name: "\(MyManager.shared().batteryCharge)%", color: XsuperColor) as! UIImage
                    
                }
                
                if(MyManager.shared().isConnected == false)
                {
                    ctx.cgContext.setFillColor(UIColor.red.cgColor)
                    print("red dot. set. ")
                }
                ctx.cgContext.setLineWidth(5)
                
                let rectangle = CGRect(x: 0, y: 0, width: 20, height: 20)
                ctx.cgContext.addEllipse(in: rectangle)
                ctx.cgContext.drawPath(using: .fillStroke)
                
            }
            
      
          
            
      
            if(!UserDefaults.standard.bool( forKey: "ConnectionStatus"))
                
            {
                
                
                let renderl = UIGraphicsImageRenderer(size: CGSize(width: 45, height: 25))
                var imgBACK = renderl.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.gray.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.gray.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
                
               
                if(cleared)
                {
                imageToSend = img.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height )
                    cleared = false
                }
                else
                {
                       imageToSend = imageToSend.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height )
                }
                var batteryPoint = CGPoint()
                
                batteryPoint.x = 20
                
           
                batteryPoint.y = watchBounds.height - 20
                if(!UserDefaults.standard.bool( forKey: "ConnectionStatus"))
                    
                {
                    
                   // imageToSend = imageToSend.overlayWith(image: imgBACK.image(alpha: 0.2)!, posX: 20, posY: watchBounds.height - 10)
                    imageToSend = imageToSend.overlayWith(image: label as! UIImage, posX: 20, posY: watchBounds.height )
             
                   
                    print("whats going on here.")
                }
                else
                {
                    
                }
                batteryPoint.x = watchBounds.width - 10
                
                
            }
            else
            {
                print("no this shouldn't be.")
                imageToSend = farImageToSend
            }
            
               //   self.imageToSend = drawImagesAndText(imageToAdd: imageToSend)
          
            
            
         
     
            
    
                print("\(currentZone) <- current Zone ")
            if(currentZone != 0)
            {
     
                
                print("a back attempt. -> \(lastColor) || currnetZone -> \(currentZone)")
                XsuperColor = UIColor.white
          
                print("a back attempt. -> \(lastColor) || currnetZone -> \(currentZone)")
                let renderla = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 25))
                var imgBACKa = renderla.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.gray.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.gray.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width:30, height: 25)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
                var label = imageWith(name: "\(currentZone)", color: currentColor) as! UIImage
               // imageToSend = imageToSend.overlayWith(image: imgBACKa.image(alpha: 0.2)!, posX: watchBounds.width - 15, posY: watchBounds.height - 10)
                imageToSend = imageToSend.overlayWith(image: label as! UIImage, posX: watchBounds.width - 15, posY: watchBounds.height )
                let message = ["tap": "one"]
                
            
                
                if(lastColor != currentZone)
                {
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    lastColor = currentZone
                }
                
                }
     
 
                    if(currentPage != MyManager.shared().currentPage) { return }
            doingUpdate = false
            
            
            XappDelegate.sendMessage(msgToSend: imageToSend)
            
            
            MyManager.shared().watchChanged = true
                      print("an attempt at sending too watch.")
            
    //        WCSession.default.sendMessageData(imageToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
            print("sent to this screenbounds: \(watchBounds.size)")
          
        }
         //
    }
    }
        

    
    
    // 3. With our session property which allows implement a method for start communication
    // and manage the counterpart response
    
    func addTextToImage(text: NSString, inImage: UIImage, atPoint:CGPoint, superColor color: UIColor) -> UIImage{
        
        // Setup the font specific variables
        let textColor = color
        let textFont = UIFont(name: "Helvetica Bold", size: 17)!
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        
        
        //Put the image into a rectangle as large as the original image.
        
        inImage.draw(in: CGRect(x: 0,y: 0, width: inImage.size.width, height: inImage.size.height), blendMode: .normal , alpha: 1.0)
  
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font:textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y: drawingBounds.size.height/2 - textSize.height/2,
                              width: textSize.width, height: textSize.height)
        
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImag as! UIImage
        
    }
    
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint, superColor color: UIColor) -> UIImage {
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica Bold", size: 12)!,NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        
        text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    MyManager.shared().watchChanged = false
    }

    
    deinit{
        timer.invalidate()
    }
    

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        rotateBounds = self.bounds
        
        pathSet = false
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        
        
        degreesOfRotation = 0.0
        
        
        switch (UserDefaults.standard.integer(forKey: "rotate"))
        {
        case 1:
            degreesOfRotation = 0.0
            break
        case 2:
            degreesOfRotation = 90.0
            break
        case 3:
            degreesOfRotation = -90.0
            break
        case 4:
            degreesOfRotation = 180.0
            break
        default:
            degreesOfRotation = 0.0
            break
        }
        tSize = self.bounds.size
        print("\(tSize) wtf?")
        
        
        if(!pathSet)
            
        {
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
                self.backgroundColor = UIColor.clear
                
                
                
                print("white")
            }
            else
            {
                
                if(MyManager.shared().currentPage != ZONE_SETUP || isBackground || isMainDraw)
                {
                    
                    print("print is backgroud 1")
                    self.backgroundColor = UIColor.clear
                }
                else
                {
                    self.backgroundColor = UIColor.black
                }
                
            }}
        else
        {
            if(MyManager.shared().currentPage != ZONE_SETUP || isBackground || isMainDraw)
            {
                print("print is backgroud 2")
                self.backgroundColor = UIColor.clear
            }
            else
            {
                self.backgroundColor = UIColor.black
            }
            
        }
        path = UIBezierPath()
        setNeedsDisplay()
        
        // Custom decoding..
    }
    
    
    func get_path() -> UIBezierPath
    {
        return path
    }
    
    func set_path(Path: UIBezierPath)
    {
        
       
        
        path = Path
        pathSet = true
        setNeedsDisplay()
    }
    
    func convert_point_watch(point: CGPoint) -> CGPoint
    {

        
        var toConvert = CGPoint()
        if(watchBounds == nil)
        {
            return toConvert
        }
        
        
        
        toConvert.x = (point.x - MyManager.shared().activeZone.origin.x ) / MyManager.shared().activeZone.size.width * watchBounds.size.width
        toConvert.y = (point.y - MyManager.shared().activeZone.origin.y) / MyManager.shared().activeZone.size.height * watchBounds.size.height
        
        
        
            toConvert = toConvert.rotate(around: rotateBounds.center, with: self.degreesOfRotation)
        print("**************** convert_point_watch toConvert \(toConvert)  self.bounds.size.width \(self.bounds.size.width)  bbbounds: \(bbbounds.size.width) ***********")

        
        return toConvert
    }
    
    
    var bbbounds : CGRect!
    func convert_point(point: CGPoint) -> CGPoint
    {
        if(bbbounds == nil){
            bbbounds = CGRect(x: 20, y: 20, width: 200, height: 200)
        }
        if(self.bounds.size.width != 0){
            bbbounds = self.bounds
        }
        var toConvert = CGPoint()
        toConvert.x = (point.x - MyManager.shared().activeZone.origin.x ) / MyManager.shared().activeZone.size.width * bbbounds.size.width
        toConvert.y = (point.y - MyManager.shared().activeZone.origin.y) / MyManager.shared().activeZone.size.height * bbbounds.size.height
        toConvert = toConvert.rotate(around: bbbounds.center, with: degreesOfRotation)

//        toConvert.x = (point.x - MyManager.shared().activeZone.origin.x ) / MyManager.shared().activeZone.size.width * self.bounds.size.width
//            toConvert.y = (point.y - MyManager.shared().activeZone.origin.y) / MyManager.shared().activeZone.size.height * self.bounds.size.height
//        toConvert = toConvert.rotate(around: self.bounds.center, with: degreesOfRotation)
      
        print("**************** convert_point toConvert \(toConvert)  self.bounds.size.width \(self.bounds.size.width)  bbbounds: \(bbbounds.size.width) ***********")

        return toConvert
    }
    
    
    func convert_to_point(point: CGPoint) -> CGPoint
    {
        
        
        var toConvert = CGPoint()
        toConvert.x = (point.x - MyManager.shared().activeZone.origin.x ) / MyManager.shared().activeZone.size.width * self.bounds.size.height
        toConvert.y = (point.y - MyManager.shared().activeZone.origin.y) / MyManager.shared().activeZone.size.height * self.bounds.size.width
        toConvert = toConvert.rotate(around: self.bounds.center, with: degreesOfRotation)

        print("convert_to_point(point: CGPoint) -> CGPoint enterpoint x \(point.x) and y \(point.y) converted x \(toConvert.x) converted y \(toConvert.y)")
        return toConvert
    }
    

   
    
    
    func move_began(point: CGPoint)
    {
        print("move_began(point: CGPoint) from drawview")

         var newPoint = convert_point(point: point)
        path.move(to: newPoint)
        lastPoint = point
        
   
        
        if(watchBounds != nil && !doingUpdate)
        {
          //  if(watchMode)
            print("wtf dude?")
     var watchpoint = convert_point_watch(point: point)
        watchPath.move(to: watchpoint)
             Watchchanged = true
   
        }
   
    changed = true
        setNeedsDisplay()
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && MyManager.shared()?.currentPage == DRAWING_MODE  && drawn && !adjusted)
        {
            print("vibrating")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        
    }
    

    
    func move_moved(point: CGPoint)
    {
        print("move_moved(point: CGPoint) from drawview")

        var newPoint = convert_point(point: point)
        // lines.append(Line(start: lastPoint, end: newPoint))
        
  
        
        if(watchBounds != nil && !doingUpdate)
        {
           // if(watchMode)
          
            
        watchPath.addLine(to: convert_point_watch(point: point))
            Watchchanged = true
        }

           changed = true
        drawn = true
        
        path.addLine(to: newPoint)
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && MyManager.shared()?.currentPage == DRAWING_MODE  && drawn && !adjusted)
        {
            print("vibrating")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        
        lastPoint = newPoint
        
   
        setNeedsDisplay()
    }
    
    
    func ended(point: CGPoint)
    {
        var newPoint = convert_point(point: point)

        path.addLine(to: newPoint)
        
        if(watchBounds != nil)
        {
            //if(watchMode)
            
        watchPath.addLine(to: convert_point_watch(point: point))
             Watchchanged = true
        }
        changed = true
        
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && MyManager.shared()?.currentPage == DRAWING_MODE  && drawn && !adjusted)
        {
            print("vibrating")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
    }
    
    
    
    
    //MARK:- draw
    override func draw(_ rect: CGRect) {
        /*  guard let context = UIGraphicsGetCurrentContext() else { return }
         
         
         context.beginPath()
         
         for line in lines {
         context.move(to: line.start)
         context.addLine(to: line.end)
         
         }
         
         
         context.setStrokeColor(UIColor.white.cgColor)
         context.strokePath()*/
        
        
        
        
        
        if(WCSession.default.isReachable)
        {
            if(!started)
            {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sendWatchMessage), userInfo: nil, repeats: true)
            print("reacheeed")
                started = true
            }
        }
        
        
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        var pathR = UIBezierPath()
        
        pathR = UIBezierPath.init(cgPath: path.cgPath)

        currentLayer.frame = rect.standardized
    
        var pathNew = UIBezierPath()
        
        pathNew = UIBezierPath.init(cgPath: pathR.cgPath)
        if
            MyManager.shared()?.currentPage == DRAWING_MODE
        { pathNew = pathNew.fit(into: self.bounds).moveCenter(to: self.bounds.center)

            
            farPath = UIBezierPath()
            farPath = UIBezierPath.init(cgPath: pathNew.cgPath)
        }
        
        
        if
            MyManager.shared()?.currentPage == DRAWING_MODE
        {
            currentLayer.path = farPath.cgPath
        }
        else
        {
            currentLayer.path = pathR.cgPath
        }
        
    if(!pathSet)
    {
        if(UserDefaults.standard.bool(forKey:"InvertColors"))
        {
             if(MyManager.shared().currentPage != ZONE_SETUP)
             {
            self.backgroundColor = UIColor.clear
            currentLayer.fillColor = UIColor.clear.cgColor
            currentLayer.strokeColor = UIColor.black.cgColor
            }
            else
             {
                self.backgroundColor = UIColor.black
                currentLayer.fillColor = UIColor.clear.cgColor
                currentLayer.strokeColor = UIColor.white.cgColor
            }
        }
        else
        {
            if(MyManager.shared().currentPage != ZONE_SETUP || isBackground || isMainDraw)
            {
                print("print is backgroud 3")
                self.backgroundColor = UIColor.clear
            }
            else
            {
                self.backgroundColor = UIColor.black
            }
            currentLayer.fillColor = UIColor.clear.cgColor
            currentLayer.strokeColor = UIColor.white.cgColor
        }}
    else{
        if(MyManager.shared().currentPage != ZONE_SETUP || isBackground || isMainDraw)
        {
            print("print is backgroud 4")
            
            self.backgroundColor = UIColor.clear
        }
        else
        {
            self.backgroundColor = UIColor.black
        }
    
        currentLayer.fillColor = UIColor.clear.cgColor
        currentLayer.strokeColor = UIColor.white.cgColor
        }
        
        
        currentLayer.lineWidth = CGFloat(UserDefaults.standard.float(forKey:"lineWidth"))
        currentLayer.contentsGravity = CALayerContentsGravity.bottom
        
        
        savedPath = UIBezierPath(cgPath: currentLayer.path as! CGPath)
        
        self.layer.addSublayer(currentLayer)
        lineCount = lineCount + 1
    
        
        

    }
    

    func makeImageWatch(with path: UIBezierPath, size: CGSize) -> UIImage {
        //        UIGraphicsBeginImageContextWithOptions(size, false, WKInterfaceDevice.current().screenScale)

        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)

        UIColor.white.setStroke()
        path.lineWidth = CGFloat(UserDefaults.standard.float(forKey:"lineWidth"))
        path.stroke()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    func makeImage(with path: UIBezierPath, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.black.setStroke()
        path.lineWidth = CGFloat(UserDefaults.standard.float(forKey:"lineWidth"))
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.imageWithInsets(insetDimen: 50.0)
    }
    
    
    func SaveAndClear(NewPoints newpoints: [(point: CGPoint, type: CGPathElementType)]? = nil)
    {
        if( savedPath.isEmpty) {return }
       
        if UIApplication.shared.statusBarOrientation.isLandscape {

            var pathTwoNew = UIBezierPath()
     
        
                if newpoints != nil {
                
                for i in 0 ..< newpoints!.count {
                    switch (newpoints![i].type.rawValue)
                    {
                    case 0:
                        var newPoint = convert_to_point(point: newpoints![i].point)
                        pathTwoNew.move(to: newPoint)
                    
                        print("\(newPoint) <- landscape test")
                        break
                    case 1:
                        var newPoint = convert_to_point(point: newpoints![i].point)
                        pathTwoNew.addLine(to: newPoint)
                        print("\(newPoint) <- landscape test")
                        break
                    case 2:
                        break
                    default:
                        break
                    }
                }
            }
            
            var newRect = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.width)
            if(currentPage == DRAWING_MODE)
            {
            pathTwoNew = pathTwoNew.fit(into: newRect).moveCenter(to: newRect.center)
            }
                MyAwesomeAlbum.shared.save(image: makeImage(with: pathTwoNew, size: newRect.size) as! UIImage)
            

            
   
        } else {
            MyAwesomeAlbum.shared.save(image: makeImage(with: savedPath, size: self.bounds.size ) as! UIImage)
            
            
        }
        
        
       
     
        print("SHOULD SAVE")
        path = UIBezierPath()
        started = true
        watchPath = UIBezierPath()
        clear()
           Watchchanged = true
        setNeedsDisplay()
        
        sendWatchMessage()
    }
    
    
    func clear()
    {
        
     
        print("clearreeeed")
      
        savedPath = UIBezierPath()
        farPath = UIBezierPath()
       
        path = UIBezierPath()
        watchPath = UIBezierPath()
    farWatchPath = UIBezierPath()
        changed = true
    
        cleared = true
        Watchchanged = true
    setNeedsDisplay()
   
     sendWatchMessage()
    }
    
    //MARK:- Adjust
    func adjust(TransitionTo tosize: CGSize, NewPoints newpoints: [(point: CGPoint, type: CGPathElementType)])
        
    {
        path = UIBezierPath()
        setNeedsDisplay()
        adjusted = true
        for i in 0 ..< newpoints.count {
            
            print("newpoints[i].type.rawValue \(newpoints[i].type.rawValue)  newpoints[i].point \(newpoints[i].point)")
            switch (newpoints[i].type.rawValue)
            {
            case 0:
                move_began(point: newpoints[i].point)
                setNeedsDisplay()
                break
            case 1:
                move_moved(point: newpoints[i].point)
                setNeedsDisplay()
                break
            case 2:
                break
            default:
                break
            }
        }
        adjusted = false
        
    }
 
}


// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!


extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: .zero, size: size)
       
        (self as NSString).draw(in: rect, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
