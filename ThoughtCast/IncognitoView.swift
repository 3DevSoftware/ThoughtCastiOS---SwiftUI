//
//  IncognitoView.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/7/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import Foundation


class IncognitoView: UIImageView

{
    
    
    var homeButton: UIButton!
     var clearButton: UIButton!
     var saveAndClearButton: UIButton!
    var Dot: UIImageView!
    var Battery: UILabel!
    var topB: UIView!
    var outV: UIView!
    var DrawingMode = false
    var actualDrawing: DrawView!
    
    
    public func initz(Buttons buttons: UIView!, OutView ov: UIView!, realDraw realView: DrawView!)
    {
        topB = buttons
        outV = ov
        actualDrawing = realView
        createPanGestureRecognizer(targetView: self)
        bringSubviewToFront(outV)
        bringSubviewToFront(topB)
        
    }
    
    

    func createPanGestureRecognizer(targetView: UIImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        
        self.addGestureRecognizer(panGesture)
    }
    
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        // get translation
  
        

        if sender.state == UIGestureRecognizer.State.ended
        {
            self.alpha = 1.0
            bringSubviewToFront(outV)
          
                homeButton.backgroundColor = UIColor.clear
                saveAndClearButton.backgroundColor = UIColor.clear
                clearButton.backgroundColor = UIColor.clear
                homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
                clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            if(DrawingMode)
            {
            
            Dot.isHidden = true
            Battery.isHidden = true
            }
            
            
            }
         bringSubviewToFront(outV)
        bringSubviewToFront(topB)
        
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.5
      
        topB.bringSubviewToFront(outV)
        bringSubviewToFront(topB)
    
        if(DrawingMode)
        {
        Dot.isHidden = false
        Battery.isHidden = false
        }
        homeButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        saveAndClearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        clearButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        homeButton.backgroundColor = UIColor.darkGray
        saveAndClearButton.backgroundColor = UIColor.darkGray
        clearButton.backgroundColor = UIColor.darkGray
        bringSubviewToFront(outV)
        bringSubviewToFront(topB)

     
    }
    
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       // self.alpha = 1.0
     
        bringSubviewToFront(outV)
        bringSubviewToFront(topB)
        
        if(DrawingMode)
        {
        Dot.isHidden = true
        Battery.isHidden = true
        }
        
        bringSubviewToFront(self)
        
        if(UserDefaults.standard.bool(forKey: "IncognitoMode") )
        {
            
            print("this part is here!")
            
            homeButton.backgroundColor = UIColor.clear
            saveAndClearButton.backgroundColor = UIColor.clear
            clearButton.backgroundColor = UIColor.clear
            homeButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            saveAndClearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            clearButton.setTitleColor(UIColor.clear, for: UIControl.State.normal)
            return
        }
    }

 
    
}
