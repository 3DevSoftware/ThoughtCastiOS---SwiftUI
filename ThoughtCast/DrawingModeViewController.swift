//
//  DrawingModeViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/5/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import AudioToolbox
import WatchConnectivity
//import WatchKit
import Bluejay


class DrawingModeViewController: UIViewController{

    var deviceName: String?
    var realAlpha: CGFloat!
    
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var connectionDot: UIImageView!
    @IBOutlet weak var topButtons: UIView!
    @IBOutlet weak var drawingViewTablet: DrawView!
    var watchBounds: CGRect!
   
    @IBOutlet weak var invertView: UIView!
    @IBOutlet weak var iPhone_SE_Height: NSLayoutConstraint!
    @IBOutlet weak var iPhone8_Height: NSLayoutConstraint!
    @IBOutlet weak var iPhone_X_Constraint: NSLayoutConstraint!
    @IBOutlet weak var topButtonsY_iPhoneSE: NSLayoutConstraint!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var stackBottom: StackBottom!
   
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var incognitoImage: UIImageView!
    
    @IBOutlet weak var topButtonsY_iPad: NSLayoutConstraint!
    @IBOutlet weak var buttonsShowing: DrawView!
    
    @IBOutlet weak var imageIncognito: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveAndClearButton: UIButton!
    
var farPoints: [(point: CGPoint, type: CGPathElementType)] = []
    
    

    //MARK:- Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        

        self.drawingViewTablet.clear()
        self.buttonsShowing.clear()

            coordinator.animate(alongsideTransition:nil) { (UIViewControllerTransitionCoordinatorContext) in
                self.drawingViewTablet.adjust(TransitionTo: size, NewPoints:  self.farPoints)
                self.buttonsShowing.adjust(TransitionTo: size, NewPoints: self.farPoints)
    }
    
    }
   
    func setBorders()
    {
        
       eraseBorders()
        
    }
    
    func eraseBorders()
    {
        homeButton.layer.borderColor = UIColor.clear.cgColor
        
        saveAndClearButton.layer.borderColor = UIColor.clear.cgColor
        
        
        clearButton.layer.borderColor = UIColor.clear.cgColor
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
            MyManager.shared()?.saveAndClear()
            print("RECEIVED SAVE")
            
            self.drawingViewTablet.SaveAndClear(NewPoints: self.farPoints)
        }
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    @objc func doClear()
    {
        DispatchQueue.main.async {
            MyManager.shared()?.clear()
            self.drawingViewTablet.clear() }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.bringSubviewToFront(refreshButton)
//        if(hasTopNotch)
//        {
//            topButtonsY_iPhoneSE.isActive = false
//            iPhone8_Height.isActive = true
//            iPhone_SE_Height.isActive = false
//            iPhone_X_Constraint.isActive = true
//            print("has top notch")
//            homeButton.contentVerticalAlignment = .bottom
//        clearButton.contentVerticalAlignment = .bottom
//            saveAndClearButton.contentVerticalAlignment = .bottom
//        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyManager.shared().drawView = self
        
        MyManager.shared().currentPage = DRAWING_MODE
        
//        UIApplication.shared.isStatusBarHidden = true
      
       homeButton.layer.borderWidth = 1.0
        
        saveAndClearButton.layer.borderWidth = 1.0
        
        
        clearButton.layer.borderWidth = 1.0
        
        homeButton.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        
        saveAndClearButton.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        
        
        clearButton.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
      /*
        incognitoImage.initz(Buttons: topButtons, OutView: self.view, realDraw: buttonsShowing)
        
        incognitoImage.homeButton = homeButton
        incognitoImage.clearButton = clearButton
        incognitoImage.saveAndClearButton = saveAndClearButton
        incognitoImage.Dot = connectionDot
        incognitoImage.Battery = batteryLabel
        incognitoImage.DrawingMode = true
        */
        
        setDot()



        drawingViewTablet.INMOVE = true
        
        if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") && !UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
                drawingViewTablet.alpha = 0.0
                buttonsShowing.alpha = 0.0
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
            eraseBorders()
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            connectionDot.alpha = 0.0
            
      
            
            batteryLabel.alpha = 0.0
            if(UserDefaults.standard.bool(forKey: "ButtonLock"))
            {
                topButtons.isHidden = true
                topButtons.alpha = 0.0
                print("hmm this")
            }
            
        }
        else
        {
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            setBorders()
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
            connectionDot.alpha = 1.0
            batteryLabel.alpha = 1.0
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
 
                homeButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                homeButton.backgroundColor = UIColor.gray
                saveAndClearButton.backgroundColor = UIColor.gray
                clearButton.backgroundColor = UIColor.gray
                    invertView.isHidden = false
            }
            drawingViewTablet.alpha = 1.0
            buttonsShowing.alpha = 1.0
        }
 

        drawingViewTablet.isHidden = true
        buttonsShowing.isHidden = false
        buttonsShowing.currentPage = DRAWING_MODE
        
        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            eraseBorders()
            buttonsShowing.isHidden = true
            drawingViewTablet.currentPage = DRAWING_MODE
            
            drawingViewTablet.isHidden = false
   
        }
        
        if UserDefaults.standard.bool(forKey:"IncognitoMode")
        {
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
          
            eraseBorders()
            buttonsShowing.isHidden = true
            drawingViewTablet.isHidden = true
            connectionDot.isHidden = true
            batteryLabel.isHidden = true
            
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
        incognitoImage.bringSubviewToFront(self.view)
        
      topButtons.bringSubviewToFront(self.view)
        

        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays") && UserDefaults.standard.bool(forKey: "ButtonLock"))
        {
            topButtons.isHidden = true
        }
        

        self.view.bringSubviewToFront(refreshButton)
        // Do any additional setup after loading the view.
    }
    




    
    
    @IBAction func refreshB(_ sender: Any) {
        
   
        
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            let message = ["tap": "one"]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
            
            }
            
        connectionDot.image = UIImage.init(named: "yellowdot")
        
        MyManager.shared().refresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setDot()
        }
        
    }
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        
          if UserDefaults.standard.bool(forKey:"IncognitoMode")
          {
        incognitoImage.addGestureRecognizer(panGesture)
        }
          else {
        targetView.addGestureRecognizer(panGesture)
        }
    }
    
    
    @objc func move_began_back(point Point: CGPoint)
    {

        buttonsShowing.move_began(point: Point)

    }
    
    
    @objc func move_moved_back(point Point: CGPoint)
    {
        print("backwords 01: \(Point)")

        
        
          buttonsShowing.move_moved(point: Point)
    }
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        // get translation
    

        self.view.bringSubviewToFront(topButtons)
   
    
        
        if sender.state == UIGestureRecognizer.State.ended
            
        {
            if( UserDefaults.standard.bool(forKey: "InvertColors"))
            {
            
                
                drawingViewTablet.alpha = 0.0
                buttonsShowing.alpha = 0.0
//                invertView.isHidden = true
                invertView.isHidden = false

            }
            
            eraseBorders()
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                drawingViewTablet.isHidden = false
                buttonsShowing.isHidden = true
                
            }
            else
            {
                setBorders()
                buttonsShowing.isHidden = false
                drawingViewTablet.isHidden = true
            }
            
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays") && UserDefaults.standard.bool(forKey: "ButtonLock"))
            {
                topButtons.isHidden = true
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
 
        
     
        print("test: \(realAlpha)")
        drawingViewTablet.alpha = realAlpha
        buttonsShowing.alpha = realAlpha
        print("hereEeeee")
        topButtons.alpha = realAlpha
        connectionDot.alpha = realAlpha
        batteryLabel.alpha = realAlpha
        invertView.alpha = realAlpha
        setBorders()
        
        if sender.state == UIGestureRecognizer.State.ended
        {
          
         
            
            if(!UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") )
            {
                
                if UserDefaults.standard.bool(forKey:"InvertColors")
                {
    //                self.invertView.isHidden = true
                    invertView.isHidden = false

                    
                    buttonsShowing.alpha = 0.0
                    drawingViewTablet.alpha = 0.0
                    
                    
                    print("white")
                }

            }
            if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") )
            {
                
    
                if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
                {
                    buttonsShowing.isHidden = true
                    drawingViewTablet.isHidden = false
                    
                }
                else
                {
                    drawingViewTablet.isHidden = true
                    buttonsShowing.isHidden = false
                }
                
                
                connectionDot.alpha = realAlpha
                
                batteryLabel.alpha = realAlpha
                drawingViewTablet.alpha = realAlpha
                buttonsShowing.alpha = realAlpha
           
                return
            }
            

            if(!UserDefaults.standard.bool(forKey: "IncognitoMode") || !UserDefaults.standard.bool(forKey: "ButtonLock"))
            {
                
                print("this part is here! two")
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                
            }
          

   
            if(UserDefaults.standard.bool(forKey: "IncognitoMode") )
            {
                imageIncognito.alpha = 1.0
                print("this part is here three!")
                incognitoImage.alpha = 1.0
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                connectionDot.alpha = 0.0
                batteryLabel.alpha = 0.0
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                           buttonsShowing.isHidden = true
                return
            }
            
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays") && UserDefaults.standard.bool(forKey: "ButtonLock"))
            {
                topButtons.isHidden = true
            }
            drawingViewTablet.alpha = 0.0
            buttonsShowing.alpha = 0.0
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
        }
    }
    
    @IBAction func saveAndClear(_ sender: UIButton) {
         let message = ["tap": "one"]
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            if(buttonsShowing == nil || !buttonsShowing.drawn) { return }
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            WCSession.default.sendMessage(message, replyHandler: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                   WCSession.default.sendMessage(message, replyHandler: nil)
            }
        }
          drawingViewTablet.SaveAndClear(NewPoints: self.farPoints)
        
        farPoints = []
      
        buttonsShowing.clear()
        
    }
    

    @objc func sAC()
    {
     
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            if(!buttonsShowing.drawn) { return }
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
            }
        }
        farPoints = []
        drawingViewTablet.SaveAndClear(NewPoints: self.farPoints)
        buttonsShowing.clear()
    }
    
    override var prefersStatusBarHidden: Bool {
        print("ok!")
        return true
    }
    
    
    
    @IBAction func homeButton(_ sender: UIButton) {
        MyManager.shared().currentPage = FRONT_PAGE
        if(buttonsShowing == nil || drawingViewTablet == nil){
            self.dismiss(animated: false, completion: nil)
            return;
        }

        let XappDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        
        XappDelegate?.sendInitialDot()
        
        
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            
            if let bs = buttonsShowing {
                if(bs.drawn) {
                    
                    if(UserDefaults.standard.bool(forKey: "AutoSaveOnHome"))
                    {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                        }
                    }
                }
            }
            
        }
        if(UserDefaults.standard.bool(forKey: "AutoSaveOnHome"))
        {
            
            drawingViewTablet.SaveAndClear(NewPoints: self.farPoints)
        }
        
        drawingViewTablet.clear()
        
        
        
        buttonsShowing.stop()
        drawingViewTablet.stop()
        
        buttonsShowing = nil
        drawingViewTablet = nil
        self.navigationController?.popToRootViewController(animated: false);
//      self.dismiss(animated: false, completion: nil)
        
        
    }
    
    @objc func move_began(point Point: CGPoint)
    {

       
        print("move_began(point Point: CGPoint) move began")
        drawingViewTablet.move_began(point: Point)
     //   drawingViewTablet.b_point(point: Point)
        
        farPoints.append((Point, CGPathElementType.moveToPoint))
        
            
    }
    
    @objc func move_moved(point Point: CGPoint)
    {
        
        
        
        print("forwards: \(Point)")
        farPoints.append((Point, CGPathElementType.addLineToPoint))
        drawingViewTablet.move_moved(point: Point)
       // drawingViewTablet.a_point(point: Point)
    }
    
    
    
    @objc func updateWatch()
    {
        drawingViewTablet.updateWatch(NewPoints: self.farPoints, newBounds: watchBounds)
        
    }
    
    @objc func setDot()
    {
        
        print("DOT SET")
        if MyManager.shared()!.isConnected
        {
            
            
            var dotWithLabel: UIImage!

              batteryLabel.text = "\(MyManager.shared()!.batteryCharge)%"
           
    
          
          
   
            
            
            if MyManager.shared()!.batteryCharge > 20 && !MyManager.shared()!.isCharging
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
            
            print("time to redraw.")
    
            
            
            
              batteryLabel.text = ""
            connectionDot.image = UIImage.init(named: "reddot")
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.bringSubviewToFront(refreshButton)
        
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
        {
            return
        }
        
        
        
        drawingViewTablet.alpha = realAlpha
        buttonsShowing.alpha = realAlpha
        buttonsShowing.alpha = realAlpha
        connectionDot.alpha = realAlpha
        batteryLabel.alpha = realAlpha
        
        batteryLabel.isHidden = false
        connectionDot.isHidden = false

 
        print("un hidden wtf")
        self.view.bringSubviewToFront(refreshButton)
        if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
        {
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            eraseBorders()
            buttonsShowing.isHidden = false
            drawingViewTablet.isHidden = true
            print("erased borders.")
        }
        else
        {
                   setBorders()
            topButtons.alpha = realAlpha
            drawingViewTablet.isHidden = false
            buttonsShowing.isHidden = true
        }
        
        if(UserDefaults.standard.bool(forKey: "IncognitoMode"))
        {
            
            imageIncognito.alpha = 0.5
            
 
            print("ok!!!!")
        }

        
        if UserDefaults.standard.bool(forKey:"InvertColors")
        {
            
            
            self.invertView.isHidden = false
            
            
                buttonsShowing.alpha = realAlpha
            drawingViewTablet.alpha = realAlpha
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                eraseBorders()
                buttonsShowing.isHidden = false
                drawingViewTablet.isHidden = true
                print("erased borders.")
            }
            else
            {
            homeButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.gray
            saveAndClearButton.backgroundColor = UIColor.gray
            clearButton.backgroundColor = UIColor.gray
            }
            print("white")
        }
        else
        {
            if(!UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                
            homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.darkGray
            saveAndClearButton.backgroundColor = UIColor.darkGray
            clearButton.backgroundColor = UIColor.darkGray
                 if(!UserDefaults.standard.bool(forKey: "IncognitoMode") )
                 {
            self.view.backgroundColor = UIColor.black
                        buttonsShowing.backgroundColor = UIColor.black
         
        
            drawingViewTablet.backgroundColor = UIColor.black
                }
            }
        }
  
   
        
  
        
        /*
 
 */
        

        if(UserDefaults.standard.bool(forKey: "ButtonLock"))
        {
            
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                topButtons.isHidden = false
                self.view.bringSubviewToFront(topButtons)
                eraseBorders()
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            }
            else
            {
                topButtons.isHidden = false
                topButtons.alpha = realAlpha
            }
            
        }
     
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
                self.view.bringSubviewToFront(refreshButton)
      
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
        {
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                drawingViewTablet.isHidden = false
                buttonsShowing.isHidden = true
                
            }
            else
            {
                buttonsShowing.isHidden = false
                drawingViewTablet.isHidden = true
            }
            
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
                self.invertView.isHidden = false
                
               
            }
                    self.view.bringSubviewToFront(refreshButton)
            
            return
        }
    
        else
        {
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
            self.invertView.isHidden = true
            }
            
        }
        
        if(!UserDefaults.standard.bool(forKey: "IncognitoMode") )
        {
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
         
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                  drawingViewTablet.isHidden = false
                buttonsShowing.isHidden = true
            }
            else
            {  buttonsShowing.isHidden = false
                drawingViewTablet.isHidden = true
            }

        }
      
        
        
        if(UserDefaults.standard.bool(forKey: "ButtonLock") && UserDefaults.standard.bool(forKey: "HideButtonOverlays") )
        {
            topButtons.isHidden = true
            print("hmm this?")
            
        }
        
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") )
        {
            drawingViewTablet.alpha = realAlpha
            buttonsShowing.alpha = realAlpha
            connectionDot.alpha = realAlpha
            batteryLabel.alpha = realAlpha
                    self.view.bringSubviewToFront(refreshButton)
            return
        }
        
        //MARK: - 0001
        if UserDefaults.standard.bool(forKey:"InvertColors")
        {
            self.invertView.isHidden = true
            
            buttonsShowing.alpha = 0.0
            drawingViewTablet.alpha = 0.0
            setBorders()
            homeButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            homeButton.backgroundColor = UIColor.white
            saveAndClearButton.backgroundColor = UIColor.white
            clearButton.backgroundColor = UIColor.white
       
            print("whitexxx")
        }
        
        if(!UserDefaults.standard.bool(forKey: "IncognitoMode") )
        {
            
            print("this part is here!")
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            eraseBorders()
            drawingViewTablet.alpha = 0.0
            buttonsShowing.alpha = 0.0
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
            self.view.bringSubviewToFront(refreshButton)
            return
            
        }
        else {   imageIncognito.alpha = 1.0 }

        
 

  
        drawingViewTablet.alpha = 0.0
        buttonsShowing.alpha = 0.0
        connectionDot.alpha = 0.0
        batteryLabel.alpha = 0.0
        
        
        if(!UserDefaults.standard.bool(forKey: "ButtonLock") &&  !UserDefaults.standard.bool(forKey: "HideButtonOverlays") )
      
      {
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
        eraseBorders()
        }
        

                self.view.bringSubviewToFront(refreshButton)
        
        


    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
                self.view.bringSubviewToFront(refreshButton)
        
        
        if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible"))
        {
            if(UserDefaults.standard.bool(forKey: "HideButtonOverlays"))
            {
                drawingViewTablet.isHidden = false
                buttonsShowing.isHidden = true
                
            }
            else
            {
                buttonsShowing.isHidden = false
                drawingViewTablet.isHidden = true
            }
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
                self.invertView.isHidden = false
                
            }
            
            return
        }
        else
        {
            if UserDefaults.standard.bool(forKey:"InvertColors")
            {
             //  self.invertView.isHidden = true
                
            }
        }
        
        if(!UserDefaults.standard.bool(forKey: "IncognitoMode") )
        {
            connectionDot.alpha = 0.0
            batteryLabel.alpha = 0.0
          
        
                print("ok!!!!")
            
        }
        else
        {
        //        imageIncognito.alpha = 1.0
            print("touch cancelled")
      //                 buttonsShowing.isHidden = true
    //        return
        }
        
        if(UserDefaults.standard.bool(forKey: "ButtonLock") && UserDefaults.standard.bool(forKey: "HideButtonOverlays") )
        {
            topButtons.isHidden = true
        
        }
        
           if(UserDefaults.standard.bool(forKey: "DrawingAlwaysVisible") )
        {
            return
        }
        
        if UserDefaults.standard.bool(forKey:"InvertColors")
        {
        //    self.view.backgroundColor = UIColor.black
            
       //    eraseBorders()
            buttonsShowing.alpha = 0.0
            drawingViewTablet.alpha  = 0.0
          
         
            print("white 2134")
        }
        else
        {
              eraseBorders()
        }

        
  
        if(drawingViewTablet == nil) { return }
        drawingViewTablet.alpha = 0.0
        connectionDot.alpha = 0.0
        batteryLabel.alpha = 0.0
        buttonsShowing.alpha = 0.0
        
    }
    
    
    @objc func clear()
    {
 
        DispatchQueue.main.async { [unowned self] in
            if(!UserDefaults.standard.bool(forKey: "DisableVibrations") )
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            
            
            self.farPoints = []
            self.drawingViewTablet.clear()
            self.buttonsShowing.clear();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNeoNotification(_:)), name: NSNotification.Name(rawValue: keyNeoNOtificationNewPage), object: nil);

    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self);
    }
    
    
    @objc func doSaveAndClear()
    {

        let message = ["tap": "one"]
    
     
        DispatchQueue.main.async { [unowned self] in
            
            if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
            {
                if(!self.buttonsShowing.drawn) { return }
                WCSession.default.sendMessage(message, replyHandler: nil)
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                }
            }
         
            print("\(self.farPoints.count) <- ok ok ok ")
               self.drawingViewTablet.SaveAndClear(NewPoints: self.farPoints)
            
             self.farPoints = []
            self.buttonsShowing.clear()
        }
        
      
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    
    @IBAction func clearButton(_ sender: UIButton) {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations") )
        {
            let message = ["tap": "one"]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                WCSession.default.sendMessage(message, replyHandler: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        WCSession.default.sendMessage(message, replyHandler: nil)
                        
                        
                        
                    }
                    
                }
                
                
            }
            
         
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        
        farPoints = []
        drawingViewTablet.clear()
        buttonsShowing.clear();
        
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
