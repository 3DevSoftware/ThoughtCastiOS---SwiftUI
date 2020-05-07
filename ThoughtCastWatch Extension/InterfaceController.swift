//
//  InterfaceController.m
//  ThoughtCast Extension
//
//  Created by Monica Kachlon on 12/18/17.
//  Copyright © 2017 ma. All rights reserved.
//


import UIKit
import WatchConnectivity
import WatchKit
import CoreGraphics


class InterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    private weak var session: WCSession?
    private var lastdelta: Double = 0.0
    private var context: CGContext?
    private var delta: Double = 0.0
    private var alpha: Double = 1.0

    private var doclear = false
    private var vibrate = false
    @IBOutlet var image: WKInterfaceImage!
    
   
    override init()
        
    {
        let message = ["justLaunched": "0"]
        print("this is it current().screenScale ************** \(WKInterfaceDevice.current().screenScale)")
        WCSession.default.sendMessage(message, replyHandler: nil)
        
        print("just launched..")
    }
    
    override func didAppear() {
 
        let message = ["justLaunched": "0"]
        WCSession.default.sendMessage(message, replyHandler: nil)
        
        print("just launched..")
    }
    
    
    override func awake(withContext context: Any?) {
        
        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            print("session")
            session!.activate()
        }


        

   
        print("sent screenbounds")
        
        print("awake with context")
        
        crownSequencer.focus()
        
        crownSequencer.delegate = self
    image.setAlpha(1.0)
        let message = ["justLaunched": "0"]
        WCSession.default.sendMessage(message, replyHandler: nil)
        
        print("just launched..")
        
        
    }
    
    

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        lastdelta = delta
        delta += rotationalDelta
        
        if delta > lastdelta {
            if alpha < 1 {
                alpha += 0.01
            }
        } else {
            if alpha > 0.2 {
                alpha -=  0.01
            }
        }
        
      
        
        image.setAlpha(CGFloat(alpha))
        print("Delta: \(delta)")
        
    }
    

    
    @IBAction func reset() {
        print("reset")
        let message = ["reset": "request"]
          WKInterfaceDevice.current().play(.click)
       WCSession.default.sendMessage(message, replyHandler: nil)
        
    }
    
    @IBAction func clear() {
        let message = ["clear": "request"]
        print("clear")
  WCSession.default.sendMessage(message, replyHandler: nil)
        //self.image.setImage(nil)
         WKInterfaceDevice.current().play(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2
        ) {
            WKInterfaceDevice.current().play(.click)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                WKInterfaceDevice.current().play(.click)
            }
            
        }
        
    }
    
    
    @IBAction func save() {
        
        
        print("save")
        
        let message = ["save": "request"]
        
  WCSession.default.sendMessage(message, replyHandler: nil)
 
         WKInterfaceDevice.current().play(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            WKInterfaceDevice.current().play(.click)
        }
        
        
        
    }
    
    
  
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("live")
        
    
        
        let messageA = ["justLaunched": "0"]
        WCSession.default.sendMessage(messageA, replyHandler: nil)
        
        print("just launched..")
        
        print("ok set the eal.")
        UIGraphicsBeginImageContext(WKInterfaceDevice.current().screenBounds.size)
        
        context = UIGraphicsGetCurrentContext()
        context!.setStrokeColor(UIColor.white.cgColor)
        context!.setLineWidth(1.0)
        context!.beginPath()
        
        
        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            print("session")
            session!.activate()
        }
        
        
        let blank = Data()
        
        
        image.setHeight(self.contentFrame.height)
        image.setWidth(self.contentFrame.width)
        let message = ["alert": "\(self.contentFrame.size.height)-\(self.contentFrame.size.width)"]
        
        WCSession.default.sendMessage(message, replyHandler: nil)
        
        
        let messagex = ["update": "go"]
        
        WCSession.default.sendMessage(messagex, replyHandler: nil)
        
        
        session!.sendMessage([
            "E": blank
            ], replyHandler: { replyMessage in
                
        }, errorHandler: { error in
            
        })
        
        

        
        
        print("xxok")
        session!.sendMessage([
            "update": "trash"
            ], replyHandler: { replyMessage in
                
        }, errorHandler: { error in
            
        })
        
    }
    
  


    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("uhh here...")
        
       
        self.image.setImageData(messageData as! Data)
        
        
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("TESTING: \(message)")
        
        
        
        message.forEach {
            
            switch($0.key as! String)
            {
            case "doUpdate":
                let messagex = ["update": "go"]
                
                WCSession.default.sendMessage(messagex, replyHandler: nil)
                break
                
            case "alert":
                let message = ["alert": "\(self.contentFrame.size.height)-\(self.contentFrame.size.width)"]
              
                WCSession.default.sendMessage(message, replyHandler: nil)
                
               //  WCSession.default.sendMessageData(Data(message) , replyHandler: nil, errorHandler: nil)
                
                print("SENT ITEM")
                
                break
            case "tap" :
                
                
                 WKInterfaceDevice.current().play(.click)
                break
                
         
            default:
                break
                
            }
            print("\(message.first?.key) <- message")
        }
        
       
        
       
        
    }
    
    
    
  
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("received data")
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    
}
