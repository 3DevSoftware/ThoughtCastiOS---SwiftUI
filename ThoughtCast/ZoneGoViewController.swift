//
//  ZoneGoViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/20/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import AudioToolbox

class ZoneGoViewController: UIViewController {
    var realAlpha: CGFloat!
    
    
    @IBOutlet weak var fingerPaintView: UIImageView!
    var passedIndex: Int!
    var imagetoLoad: Bool?
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var connectionDot: UIImageView!
    @IBOutlet weak var zoneGoView: DrawView!
    @IBOutlet weak var topButtons: UIStackView!
    
    @IBOutlet weak var invertView: UIView!
    var paintNil = false
    var watchBounds: CGRect!
    
    @IBOutlet weak var dotStack: UIStackView!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var saveAndClearButton: UIButton!
    
    @IBOutlet weak var imageIncognito: UIImageView!
    
    //   @IBOutlet weak var imageIncognito: IncognitoView!
    @IBOutlet weak var zoneGoBackground: DrawView!
    var farPoints: [(point: CGPoint, type: CGPathElementType)] = []
    var redrawfarPoints: [(point: CGPoint, type: CGPathElementType)] = []
    @IBOutlet weak var buttonsShowing: DrawView!
    @IBOutlet weak var fingerPaintTemplate: UIImageView!
    var degreesOfRotation: CGFloat!
    
    @IBOutlet weak var zoneBackgroundTemplate: UIImageView!
    @IBOutlet weak var oneLabel: UILabel!
    var stopVibrate = false as! Bool
    var toVibrate : Int?
    var fingerFrame: CGRect!
    var paintTemplate: UIImage!
    var vibrating = false as! Bool
    var globalVibrating = 0 as! Int
    var x = UserDefaults.standard.integer(forKey:"zonevibrates") as! Int
    var lastVibration = 0 as! Int
    var currentVibration: Int!
    var lSize: CGSize!
    var rotate = false
    var bgTemplate: UIImage!
    var loaded = false
    var backgroundTemplate: UIImage!
    @IBOutlet weak var backgroundTemplateX: DrawView!
    
    var pathToDraw: UIBezierPath!
    
    @IBOutlet weak var imageBackgroundTemplate: UIImageView!
    
    
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.zoneGoView.clear()
        self.buttonsShowing.clear()
        print("haha")
        lSize = size
        rotate = true
        
        
    }
    
    @objc
    func rotated() {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            self.zoneGoView.clear()
            self.buttonsShowing.clear()
            lSize = self.view.bounds.size
            self.zoneGoView.adjust(TransitionTo: lSize, NewPoints: self.farPoints)
            self.buttonsShowing.adjust(TransitionTo: lSize, NewPoints: self.farPoints)
        }
    }
    
    
    
    
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if(hasTopNotch)
        {
            homeButton.contentVerticalAlignment = .bottom
            clearButton.contentVerticalAlignment = .bottom
            saveAndClearButton.contentVerticalAlignment = .bottom
        }
        
        
        MyManager.shared()?.zoneGo = self
        
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
        
        backgroundTemplateX.isBackground = true
        
        
        buttonsShowing.isMainDraw = true
        zoneGoView.isMainDraw = true
        
     
        if(UserDefaults.standard.bool(forKey: "ShowTemplate"))
        {
            
            if(!UserDefaults.standard.bool(forKey:
                "DrawingAlwaysVisible"))
            {
                backgroundTemplateX.alpha = 0.0
                buttonsShowing.isHidden = false
            }
            else
            {
                backgroundTemplateX.alpha = 1.0
            }
            
        }
        
        stopVibrate = false
        MyManager.shared()?.currentPage = ZONE_GO
        
        
        zoneGoView.currentPage = ZONE_GO
        createPanGestureRecognizer(targetView: self.view)
        realAlpha = 1.0
        
        
        print("zone mode: alert")
        
        
        
        
        fingerPaintView.frame = fingerFrame
        
       
        
        
        zoneGoView.INMOVE = true
        buttonsShowing.INMOVE = false
        
        
        fingerPaintView.frame = fingerFrame
        zoneGoBackground.frame = fingerFrame
        
        
  
        
        
        //    var ok = UserDefaults.standard.data(forKey: "zoneTemplate") as! Data
        
        
        lSize = self.view.bounds.size
        
        
        
        
        
        
        clearButton.bringSubviewToFront(self.view)
             self.view.bringSubviewToFront(imageIncognito)
        setDot()
        // Do any additional setup after loading the view.
        
        
        
        
        if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && !UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
            zoneGoView.alpha = 0.0
            buttonsShowing.alpha = 1.0
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
          
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
            buttonsShowing.alpha = 0.0
             self.view.bringSubviewToFront(topButtons)
            if(UserDefaults.standard.bool(forKey: "ButtonLock"))
            {
                topButtons.alpha = 0.0
            }
            
        }
        else
        {
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
            connectionDot.alpha = 1.0
            batteryLabel.alpha = 1.0
            zoneGoView.alpha = 1.0
            buttonsShowing.alpha = 1.0
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
                
                buttonsShowing.isHidden = true
                zoneGoView.isHidden = false
            }
            else
            {
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
            }
        }
        
        if !( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            oneLabel.isHidden = true
        }
        
        
        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            eraseBorders()
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            buttonsShowing.isHidden = true
            
            //         incognitoImage.initz(Buttons: topButtons, OutView: self.view, realDraw: zoneGoView)
            backgroundTemplateX.frame = zoneGoView.frame
            zoneGoView.isHidden = false
             self.view.bringSubviewToFront(topButtons)
        }
        else
        {
            
            //   incognitoImage.initz(Buttons: topButtons, OutView: self.view, realDraw: buttonsShowing)
            backgroundTemplateX.frame = buttonsShowing.frame
            buttonsShowing.isHidden = false
            zoneGoView.isHidden = true
        }
        
        if UserDefaults.standard.bool(forKey:"IncognitoMode")
        {
            //   topButtons.isHidden = true
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
                
                buttonsShowing.isHidden = true
                zoneGoView.isHidden = false
            }
            else
            {
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
            }
            
            
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
         
             self.view.bringSubviewToFront(topButtons)
            
            print("Loading incognito.")
            imageIncognito.isHidden = false
            let fileURL = UserDefaults.standard.url(forKey: "incognitoImage")
            if(fileURL != nil)
            {
                do {
                    let imageData = try Data(contentsOf: fileURL!)
                    imageIncognito.image = UIImage(data: imageData)
                    
                    
                } catch {
                    
                }
            }
            
        }
        else
        {
            imageIncognito.isHidden = true
        }
        realAlpha = 1.0
        createPanGestureRecognizer(targetView: self.view)
        // incognitoImage.bringSubviewToFront(self.view)
        
        
        if UserDefaults.standard.bool(forKey:"InvertColors") && !UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible")
        {
            self.invertView.isHidden = true
        }
        else
        {
             self.invertView.isHidden = true
            if UserDefaults.standard.bool(forKey:"IncognitoMode")
            {
                self.view.backgroundColor = UIColor.clear
                zoneGoView.backgroundColor = UIColor.clear
                connectionDot.alpha = 0.0
                batteryLabel.alpha = 0.0
                
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                
            }
            else
            {
                self.view.backgroundColor = UIColor.black
                zoneGoView.backgroundColor = UIColor.black
                
            }
        }
        
        self.view.bringSubviewToFront(buttonsShowing)
        topButtons.alpha = realAlpha
        
 
        if( !UserDefaults.standard.bool(forKey: "InvertColors"))
        {
            invertView.isHidden = true
        }
        
        
        if(UserDefaults.standard.bool(forKey: "ShowTemplate"))
        {
            
            print("Should work")
            
            
            
            if(!UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                backgroundTemplateX.frame = buttonsShowing.frame
                
            }
            else
            {
                backgroundTemplateX.frame = zoneGoView.frame
            }
            
            
            if(UserDefaults.standard.bool(forKey:"DrawingAlwaysVisible"))
            {
                if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                {
                    
                
                    self.view.bringSubviewToFront(zoneGoView)
                    zoneGoView.backgroundColor  = UIColor.clear
                        self.view.bringSubviewToFront(backgroundTemplateX)
                    
                }
                else
                {
                    
                    
                    
                   
                    self.view.bringSubviewToFront(buttonsShowing)
                     self.view.bringSubviewToFront(backgroundTemplateX)
                    buttonsShowing.isHidden = false
                    backgroundTemplateX.isHidden = true
                    buttonsShowing.backgroundColor = UIColor.clear
                    
                }
                backgroundTemplateX.isHidden = false
            }
            else
            {
                if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                {
                    
    
                    self.view.bringSubviewToFront(zoneGoView)
                                    self.view.bringSubviewToFront(backgroundTemplateX)
                    zoneGoView.backgroundColor  = UIColor.clear
                    
                }
                else
                {
                    
                    
     
                    self.view.bringSubviewToFront(buttonsShowing)
                        self.view.bringSubviewToFront(backgroundTemplateX)
                    buttonsShowing.backgroundColor = UIColor.clear
                    
                }
                backgroundTemplateX.isHidden = false
                
                //
            }
            backgroundTemplateX.adjust(TransitionTo: lSize, NewPoints: self.redrawfarPoints)
            print("ADJUSTED.")
          
            
            if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && UserDefaults.standard.bool(forKey: "ButtonLock") )
            {
                topButtons.isHidden = true
            }
            self.view.bringSubviewToFront(
                refreshButton)
            
        }
        
      
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && UserDefaults.standard.bool(forKey: "InvertColors") )
        {
            invertView.isHidden = false
        }
   
        if(paintTemplate != nil && !paintNil)
        {
         //   paintTemplate =  resize(image: paintTemplate, toScaleSize: fingerFrame.size)
            paintTemplate = resizeImage(image: paintTemplate, targetSize: fingerFrame.size)
            fingerPaintView.image = paintTemplate
            
        }
        
        self.view.bringSubviewToFront(imageIncognito)
          self.view.bringSubviewToFront(dotStack)
        
        self.view.bringSubviewToFront(topButtons) 
       
        
       
        
    }
    
    func resize(image: UIImage, toScaleSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toScaleSize, true, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: toScaleSize.width, height: toScaleSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
    
    func setBorders()
    {
       eraseBorders()
        
    }
    
    func eraseBorders()
    {
    }
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        
        targetView.addGestureRecognizer(panGesture)
        // incognitoImage.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height *      widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return newImage!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if rotate
        {
            print("should be done rotating")
            self.zoneGoView.adjust(TransitionTo: lSize, NewPoints: self.farPoints)
            self.buttonsShowing.adjust(TransitionTo: lSize, NewPoints: self.farPoints)
            
            rotate = false
        }
        
        if(UserDefaults.standard.bool(forKey: "ShowTemplate"))
        {
              self.backgroundTemplateX.adjust(TransitionTo: lSize, NewPoints: self.redrawfarPoints)
            print("Should work")
            
            
            
            if(!UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                backgroundTemplateX.frame = buttonsShowing.frame
                
            }
            else
            {
                backgroundTemplateX.frame = zoneGoView.frame
            }
            
            
            if(!UserDefaults.standard.bool(forKey:"DrawingAlwaysVisible"))
            {
                if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                {
                    
                    self.view.bringSubviewToFront(backgroundTemplateX)
                    self.view.bringSubviewToFront(zoneGoView)
                    zoneGoView.backgroundColor  = UIColor.clear
                    
                }
                else
                {
                    
                    self.view.bringSubviewToFront(backgroundTemplateX)
                      self.view.bringSubviewToFront(buttonsShowing)
                    
                  buttonsShowing.isHidden = false
                    
                    
                }
                backgroundTemplateX.isHidden = false
            }
            else
            {
                if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                {
                    
                    self.view.bringSubviewToFront(backgroundTemplateX)
                    self.view.bringSubviewToFront(zoneGoView)
                    zoneGoView.backgroundColor  = UIColor.clear
                    
                }
                else
                {
                    
                                      self.view.bringSubviewToFront(backgroundTemplateX)
                    self.view.bringSubviewToFront(buttonsShowing)
  
                    
                    
                    
                }
                backgroundTemplateX.isHidden = false
               
                //
            }
            
   
            
            backgroundTemplateX.adjust(TransitionTo: lSize, NewPoints: self.redrawfarPoints)
            print("ADJUSTED.")
            
       
            if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && UserDefaults.standard.bool(forKey: "ButtonLock") )
            {
                topButtons.isHidden = true
            }
            
        }
  
        

    
           self.view.bringSubviewToFront(imageIncognito)
            self.view.bringSubviewToFront(topButtons)
          self.view.bringSubviewToFront(dotStack)
        self.view.bringSubviewToFront(
            refreshButton)
    }
    
    @IBAction func click(_ sender: Any) {
        
        print("clicked")
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            let message = ["tap": "one"]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        connectionDot.image = UIImage.init(named: "yellowdot")
        
        MyManager.shared().refresh()
        
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setDot()
        }
    }
    
    
    @objc func setDot()
    {
        
        if MyManager.shared()!.isConnected
        {
            
            print("not reconnecting ey?")
            if(watchBounds == nil)
            {
                let message = ["alert": "go"]
                
                WCSession.default.sendMessage(message, replyHandler: nil)
                
            }
     
            
            var dotWithLabel: UIImage!
            
            batteryLabel.text = "\(MyManager.shared()!.batteryCharge)%"
            print("\(MyManager.shared()!.batteryCharge) <- wtf? ")
            if MyManager.shared()!.batteryCharge > 20 && !MyManager.shared().isCharging
            {
                
                
                batteryLabel.textColor = UIColor.green
                connectionDot.image = UIImage.init(named: "greendot")
            }
            else
            {
                batteryLabel.textColor = UIColor.orange
                connectionDot.image = UIImage.init(named: "orangedot")
            }
            
            
        }
        else
        {
            print("here so wtf.")
            if(watchBounds == nil)
            {
                let message = ["alert": "go"]
                
                WCSession.default.sendMessage(message, replyHandler: nil)
                
            }
            
      
            
            print("updating to red dot.")
            batteryLabel.text = ""
            connectionDot.image = UIImage.init(named: "reddot")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") || UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
            self.view.bringSubviewToFront(imageIncognito)
            
            return
        }
        
         if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && UserDefaults.standard.bool(forKey: "ButtonLock") && UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
         {
            topButtons.isHidden = true
            
        }
        else
         {
            topButtons.isHidden = false
        }
        zoneGoView.alpha = 0.0
        connectionDot.alpha = 0.0
        batteryLabel.alpha = 0.0
        buttonsShowing.alpha = 0.0
        
    
        
        if( !UserDefaults.standard.bool(forKey: "InvertColors"))
        {
                invertView.isHidden = true
        }
        

        backgroundTemplateX.alpha = 0.0
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   self.view.bringSubviewToFront(imageIncognito)
        
        if( UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
            zoneGoView.alpha = 1.0
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
            imageIncognito.alpha = 1.0
            
            backgroundTemplateX.alpha = 0.0
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
             
                    
                    buttonsShowing.isHidden = true
                    zoneGoView.isHidden = false
            
                
            }
            else
            {
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                 self.view.bringSubviewToFront(topButtons)
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
            }
            return
        }
        
        
        
        if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && UserDefaults.standard.bool(forKey: "ButtonLock") && UserDefaults.standard.bool(forKey: "HideButonOverlays") )
        {
            topButtons.isHidden = true
            
        }
     
            else if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && !UserDefaults.standard.bool(forKey: "ButtonLock") && UserDefaults.standard.bool(forKey: "HideButonOverlays"))
        {
            topButtons.isHidden = false
            }
    
        else if ( UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
        {
            return
        }
        else {
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
             self.view.bringSubviewToFront(topButtons)
            eraseBorders()
        }
        
        
        invertView.isHidden = true
     
             topButtons.isHidden = true
        zoneGoView.alpha = 0.0
        connectionDot.alpha = 0.0
        backgroundTemplateX.alpha = 0.0
        batteryLabel.alpha = 0.0
        buttonsShowing.alpha = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
      
        self.view.bringSubviewToFront(topButtons)
           self.view.bringSubviewToFront(refreshButton)
      self.view.bringSubviewToFront(zoneGoView)
        self.view.bringSubviewToFront(buttonsShowing)
      

        loaded = true
        backgroundTemplateX.adjust(TransitionTo: lSize, NewPoints: self.redrawfarPoints)
        if(UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
            connectionDot.alpha = 1.0
            batteryLabel.alpha = 1.0
            zoneGoView.alpha = 1.0
            imageIncognito.alpha = 0.5
            
            backgroundTemplateX.alpha = realAlpha
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
           
         
                
                buttonsShowing.isHidden = true
                zoneGoView.isHidden = false
            }
            else
            {
                
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
                setBorders()
                homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                homeButton.backgroundColor = UIColor.darkGray
                saveAndClearButton.backgroundColor = UIColor.darkGray
                clearButton.backgroundColor = UIColor.darkGray
                topButtons.alpha = realAlpha
            }
            
            
              self.view.bringSubviewToFront(topButtons)
            return
        }
        
        
        topButtons.alpha = realAlpha
        
        backgroundTemplateX.alpha = realAlpha
        
        print("doneeee")
        zoneGoView.alpha = realAlpha
        buttonsShowing.alpha = realAlpha
        connectionDot.alpha = realAlpha
        backgroundTemplateX.alpha = realAlpha
        batteryLabel.alpha = realAlpha
        imageIncognito.isHidden = true
          setBorders()
        backgroundTemplateX.alpha = realAlpha
        
        if( UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
            setBorders()
        }
        
   
        if(UserDefaults.standard.bool(forKey: "ButtonLock"))
        {
            topButtons.isHidden = false
            topButtons.alpha = realAlpha
        }
        
        if( UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
        {
                    if( UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                eraseBorders()
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                print("buttons hidden.")
            }
        return
        }
        
        if( !UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
        }
        else
        {
            eraseBorders()
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            print("buttons hidden.")
        }
        

        
        if UserDefaults.standard.bool(forKey:"InvertColors")
        {
           
            invertView.isHidden = false
            homeButton.backgroundColor = UIColor.white
            saveAndClearButton.backgroundColor = UIColor.white
            clearButton.backgroundColor = UIColor.white
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            eraseBorders()
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
                
                buttonsShowing.isHidden = true
                zoneGoView.isHidden = false
            }
            else
            {
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
            }
      
        
            zoneGoView.alpha = 1.0
            buttonsShowing.alpha = 1.0
            print("erased borders.")
            
        }
        else
        {     homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
            invertView.isHidden = true
            
        }
    
      
        print("made it here. \(self.redrawfarPoints)")
        self.view.bringSubviewToFront(backgroundTemplateX)
        self.view.bringSubviewToFront(buttonsShowing)
        self.view.bringSubviewToFront(zoneGoView)
          self.view.bringSubviewToFront(topButtons)
        
        if UserDefaults.standard.bool(forKey:"InvertColors")
        {
          
        }
           if( !UserDefaults.standard.bool(forKey: "ShowTemplate"))
           {
            backgroundTemplateX.isHidden = true 
        }
    }
    
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        // get translation
        if sender.state == UIGestureRecognizer.State.ended
        {
            
            if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") || !UserDefaults.standard.bool(forKey: "InvertColors"))
            {
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                zoneGoView.alpha = 0.0
                
                backgroundTemplateX.alpha = 0.0
                connectionDot.alpha = 0.0
                buttonsShowing.alpha = 0.0
                batteryLabel.alpha = 0.0
                return
            }
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                buttonsShowing.isHidden = true
                zoneGoView.isHidden = false
            }
            else
            {
                buttonsShowing.isHidden = false
                zoneGoView.isHidden = true
            }
        }
        
        
        var vel = sender.velocity(in: self.view)
        if (vel.y > 0.1)
        {
            //  NSLog(@"down");
            
            if(realAlpha > 0.1)
            {
                realAlpha -= 0.025;
            }
        }
        else
        {
            if(realAlpha < 1)
            {
                realAlpha += 0.025;
            }
        }
        
        
        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            
            
            buttonsShowing.isHidden = true
            zoneGoView.isHidden = false
        }
        else
        {
            buttonsShowing.isHidden = false
            zoneGoView.isHidden = true
        }
        
        invertView.alpha = realAlpha
        zoneGoView.alpha = realAlpha
        topButtons.alpha = realAlpha
        connectionDot.alpha = realAlpha
        batteryLabel.alpha = realAlpha
        buttonsShowing.alpha = realAlpha
        zoneGoBackground.alpha = realAlpha
         self.view.bringSubviewToFront(topButtons)
        backgroundTemplateX.alpha = realAlpha
        print("testing.. \(realAlpha)  <- alpha")
        if sender.state == UIGestureRecognizer.State.ended
        {
            if( UserDefaults.standard.bool(forKey: "IncognitoMode"))
            {
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                //incognitoImage.alpha = 1.0
                imageIncognito.alpha = 1.0
                
                backgroundTemplateX.alpha = 0.0
                connectionDot.alpha = 0.0
                batteryLabel.alpha = 0.0
                zoneGoView.alpha = 1.0
                
                self.view.bringSubviewToFront(imageIncognito)
                 self.view.bringSubviewToFront(topButtons)
                return
            }
            
            if( UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
            {
                
                return
            }
            
            if( UserDefaults.standard.bool(forKey: "ButtonLock") || UserDefaults.standard.bool(forKey: "HideButtonOverlays") )
            {
                
                topButtons.isHidden = false
                return
            }
            
            if( UserDefaults.standard.bool(forKey: "InvertColors"))
            {
                     invertView.isHidden = true
            }
        
       
            
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            eraseBorders()
            zoneGoView.alpha = 0.0
            
            backgroundTemplateX.alpha = 0.0
            connectionDot.alpha = 0.0
            buttonsShowing.alpha = 0.0
            batteryLabel.alpha = 0.0
             self.view.bringSubviewToFront(topButtons)
        print("all the way here.")
            
       
         
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNeoNotification(_:)), name: NSNotification.Name(rawValue: keyNeoNOtificationNewPage), object: nil);

    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self);

    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        
        stopVibrate = true
        
        let XappDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        
        XappDelegate?.sendInitialDot()
        
        
        
        zoneGoView.clear()
        
        if(UserDefaults.standard.bool(forKey: "AutoSaveOnHome"))
        {
            
            zoneGoView.SaveAndClear(NewPoints: self.farPoints)
        }
        

        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyBoard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC = storyBoard.instantiateViewController(withIdentifier: "mainnavigation")
        
        
        self.dismiss(animated: false, completion: nil)
 

//        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        if(UIDevice.current.userInterfaceIdiom == .pad){
//            storyBoard = UIStoryboard(name: "Maini", bundle: nil)
//        }
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainpage") as! ViewController
//        self.present(newViewController, animated: false, completion: nil)
        
   
        
        
    }
    @objc func doReset()
    {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        MyManager.shared()?.refresh()
    }
    
    @objc func doSave()
    {
        DispatchQueue.main.async {
            if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                }
            }
             self.zoneGoView.SaveAndClear(NewPoints: self.farPoints)
            self.farPoints = []
           
            self.zoneGoBackground.clear()
            self.buttonsShowing.clear()
        }
    }
    
    @objc func doClear()
    {
        DispatchQueue.main.async {
            if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            self.farPoints = []
            self.zoneGoBackground.clear()
            self.buttonsShowing.clear()
            self.zoneGoView.clear()
        }
        
    }
    
    @IBAction func saveAndClear(_ sender: Any) {
        
        let message = ["tap": "one"]
        
        
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                WCSession.default.sendMessage(message, replyHandler: nil)
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
            }
        }
              zoneGoView.SaveAndClear(NewPoints: self.farPoints)
        farPoints = []
  
        zoneGoBackground.clear()
        buttonsShowing.clear()
        
    }
    
    
    
    /*
     case "save" :
     DispatchQueue.main.async {
     if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
     {
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     
     }
     }
     self.farPoints = []
     self.zoneGoView.SaveAndClear()
     self.zoneGoBackground.clear()
     self.buttonsShowing.clear()
     }
     break
     
     case "clear":
     
     DispatchQueue.main.async {
     if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
     {
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     }
     self.farPoints = []
     self.zoneGoBackground.clear()
     self.buttonsShowing.clear()
     self.zoneGoView.clear()
     }
     
     break
     
     case "reset" :
     if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
     {
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     }
     MyManager.shared()?.refresh()
     break
     
     
     */
    
    
    @objc func doSaveAndClear()
    {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
            }
        }
    
        zoneGoView.SaveAndClear(NewPoints: self.farPoints)
          farPoints = []
        zoneGoBackground.clear()
        buttonsShowing.clear()
    }
    
    
    @objc func clear()
    {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        zoneGoBackground.clear()
        buttonsShowing.clear()
        zoneGoView.clear()
        farPoints = []
    }
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        
        let message = ["tap": "one"]
        
        
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") && !self.vibrating)
        {
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                WCSession.default.sendMessage(message, replyHandler: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    
                    
                    
                }
                
            }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        zoneGoBackground.clear()
        buttonsShowing.clear()
        zoneGoView.clear()
        farPoints = []
    }
    
    @objc func move_began(point Point: CGPoint)
    {
        
        
        let XappDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        XappDelegate!.somethingDrawn = true
        
        
        
        
        farPoints.append((Point, CGPathElementType.moveToPoint))
        
        
        
        zoneGoView.move_began(point: Point)
        buttonsShowing.move_began(point: Point)
    }
    
    @objc func move_moved(point Point: CGPoint)
    {
        
        
        
        let XappDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        XappDelegate!.somethingDrawn = true
        
        farPoints.append((Point, CGPathElementType.addLineToPoint))
        
        
        zoneGoView.move_moved(point: Point)
        buttonsShowing.move_moved(point: Point)
    }
    
    @objc func redrawWatch()
    {
        zoneGoView.updateWatch(NewPoints: farPoints, newBounds: watchBounds)
    }
    
    
    
    
    @objc func move_began_back(point Point: CGPoint)
    {
        
        zoneGoBackground.move_began(point: Point)
        
        
        // var colorDetected = getPixelColor(fingerPaintView.image!,  Point)
        
        
        if(Point.x <= 0 || Point.y <= 0 ) { return }
        if(Point.y >=  fingerFrame.maxY || Point.x >= fingerFrame.maxX) { return }
        
        
        print("\(Point) <- debug point")
        
        
        var color = UIColor.clear
        if(paintTemplate == nil) { return }
        
        
        
        
        var colorChoice = paintTemplate.getPixelColor(point: convert_point(point: Point))
        
        
        
        
        vibrate(currentColor: colorChoice)
        
        print("\(colorChoice) ")
        
    }
    
    func convert_point(point: CGPoint) -> CGPoint
    {
        
        var toConvert = CGPoint()
        
        
        
        
        toConvert.x = (point.x - MyManager.shared().activeZone.origin.x ) / MyManager.shared().activeZone.size.width * fingerFrame.size.width
        toConvert.y = (point.y - MyManager.shared().activeZone.origin.y) / MyManager.shared().activeZone.size.height * fingerFrame.size.height
        
        
        
        toConvert = toConvert.rotate(around: fingerFrame.center
            , with: degreesOfRotation)
        
        return toConvert
    }
    
    
    
    
    func do_vibrate(count Count: Int, cColor CurrentColor: UIColor)
        
    {
        
        if self.vibrating == true
        {
            
            return
        }
        
        
        print("Last Count: \(Count)")
        
        var currentCount = Count
        var outerCount = Count
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            self.vibrating = true
            var l = 0
            
            while(l < self.x)
                
            {
                if(self.stopVibrate)
                { break }
                for i in 0..<currentCount {
                    
                    
                    if(currentCount != nil && currentCount != 0)
                    {
                        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                        {
                            self.zoneGoView.currentZone = currentCount as! Int
                            self.zoneGoView.currentColor = CurrentColor as! UIColor
                        }
                        else
                        {
                            self.buttonsShowing.currentZone = currentCount as! Int
                            self.buttonsShowing.currentColor = CurrentColor as! UIColor
                        }
                    }
                    
                    if(self.stopVibrate)
                    { break }
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    usleep(833333)
                    print("\(i) -> current Count \(Count)")
                }
                if(self.stopVibrate)
                { break }
                sleep(1)
                l += 1
                if(outerCount != self.toVibrate && self.toVibrate != nil)
                {
                    l = 0
                    
                    
                    currentCount = self.toVibrate!
                    outerCount = self.toVibrate!
                    
                }
            }
            
            self.vibrating = false
        }
        
        
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        print("ok!")
        return true
    }
    
    func vibrate(currentColor Color: UIColor)
    {
        
        
        
        
        print("Here::: \(Color.hex)")
        switch (Color.hex)
        {
        case UIColor.red.hex:
            toVibrate = 1
            
            oneLabel.textColor = UIColor.red
            break;
        case UIColor.orange.hex:
            toVibrate = 2
            
            
            oneLabel.textColor = UIColor.orange
            break;
        case UIColor.yellow.hex:
            toVibrate = 3
            
            oneLabel.textColor = UIColor.yellow
            break;
        case UIColor.green.hex:
            
            oneLabel.textColor = UIColor.green
            print("green stuck")
            toVibrate = 4
            break;
        case UIColor.blue.hex:
            
            oneLabel.textColor = UIColor.blue
            toVibrate = 6
            break;
        case UIColor.cyan.hex:
            
            oneLabel.textColor = UIColor.cyan
            toVibrate = 5
            break;
        case UIColor.purple.hex:
            
            oneLabel.textColor = UIColor.purple
            toVibrate = 7
            break;
        case UIColor.magenta.hex:
            
            oneLabel.textColor = UIColor.magenta
            toVibrate = 8
            break;
            
        case UIColor.white.hex:
            oneLabel.textColor = UIColor.white
            toVibrate = 9
            break;
            
        default:
            toVibrate = nil
            break;
        }
        
        
        
        if(toVibrate != nil && toVibrate != 0)
        {
            zoneGoView.currentZone = toVibrate!
            buttonsShowing.currentZone = toVibrate!
            zoneGoView.currentColor = Color
            buttonsShowing.currentColor = Color
        }
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            
            if(toVibrate != nil)
            {
                oneLabel.text = "\(toVibrate!)"
            }
        }
        
        if toVibrate != nil {
            do_vibrate(count: toVibrate!, cColor: Color)
            print("Testing: \(toVibrate!)")
            
        }
        
    }
    
    
    
    
    
    
    @objc func move_moved_back(point Point: CGPoint)
    {
        // var colorDetected = getPixelColor(fingerPaintView.image!,  Point)
        // var colorDetected = getPixelColor(fingerPaintView.image!,  Point)
        
        
        
        
        
        print("atttemping")
        
        
        if(Point.x <= 0 || Point.y <= 0 ) { return }
        if(Point.y >= fingerFrame.maxY || Point.x >= fingerFrame.maxX) { return }
        
        if(paintTemplate == nil) { return }
        
        
        
        print("\(Point) <- debug point")
        
        
        var colorChoice = paintTemplate.getPixelColor(point: convert_point(point: Point))
        
        
        //var colorChoice = paintTemplate![Int(convert_point(point: Point).x), Int(convert_point(point: Point).y)] as! UIColor
        print("\(colorChoice)")
        
        
        vibrate(currentColor: colorChoice as! UIColor)
        
        
        print("\(colorChoice) - in hex \(colorChoice.hex) ")
        zoneGoBackground.move_moved(point: Point)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: - NEO Notifications
    @objc
    func receiveNeoNotification(_ notification: NSNotification){
        if let newpage = notification.userInfo?["newpage"] as? Bool {
            if(newpage){
                if(UserDefaults.standard.bool(forKey: "AutoSave"))
                {
                    self.saveAndClear(UIButton())
                }
                print("*********************** newpage *****************");
            }
        }
    }
}

