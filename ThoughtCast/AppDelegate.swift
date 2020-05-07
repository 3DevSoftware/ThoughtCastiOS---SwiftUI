//
//  AppDelegate.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/2/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import Firebase
import Bugsnag
import WatchConnectivity
//import WatchKit
import CommonCrypto
import CoreBluetooth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, CBCentralManagerDelegate  {
    
    
    var initialDot = false
    var watchBounds:  CGRect!
    var window: UIWindow?
 let session = WCSession.default
    var cbCentralManager: CBCentralManager!
    
    var somethingDrawn = false
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }


    
    func randomNumber(with digit: Int) -> Int? {
        
        guard 0 < digit, digit < 20 else { // 0 digit number don't exist and 20 digit Int are to big
            return nil
        }
        
        /// The final ramdom generate Int
        var finalNumber : Int = 0;
        
        
        for i in 1...digit {
            
            /// The new generated number which will be add to the final number
            var randomOperator : Int = 0
            
            repeat {
                #if os(Linux)
                randomOperator = Int(random() % 9) * Int(powf(10, Float(i - 1)))
                #else
                randomOperator = Int(arc4random_uniform(9)) * Int(powf(10, Float(i - 1)))
                #endif
                
            } while Double(randomOperator + finalNumber) > Double(Int.max) // Verification to be sure to don't overflow Int max size
            
            finalNumber += randomOperator
        }
        
        return finalNumber
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func CheckTime()
    {
        let currentDate = Date()
        print("-> time test -> \(currentDate.timeText())")
    }
    
    func imageWith(name: String?, color: UIColor) -> UIImage? {
        let text = name as! String
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let textSize = text.size(withAttributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
        let rect = CGRect(origin: .zero, size: textSize)
        text.draw(with: rect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    @objc func checkHash(doNew: Bool = false)
    {
        if FirebaseApp.app() == nil
        {
            FirebaseApp.configure()
        }
        
        
        if(!UserDefaults.standard.bool(forKey: "LoggedIn")) { return }
        
        let currentDateTime = Date()
        
        // get the user's calendar
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        print("\(dateTimeComponents.minute!) <- minutes")
            
        if((dateTimeComponents.minute! == 00  || dateTimeComponents.minute! == 15 || dateTimeComponents.minute! == 30  || dateTimeComponents.minute! == 45 || doNew || dateTimeComponents.minute! == 13)) {
        print("GOING!!! \(dateTimeComponents.minute!)")
        print("time testing...")
        let db = Firestore.firestore()
       let username = UserDefaults.standard.string(forKey: "loggedInAs") as? String
        let passwordX = UserDefaults.standard.string(forKey: "loggedInPassword") as? String
        let loginID = UserDefaults.standard.string(forKey: "loginID") as? String
        
        if(username == nil) {
            print("ok?? why not")
            return }
        if(passwordX == nil) { return }
        if(loginID == nil) { return }
        let docRef = db.collection("users").document(username!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let password = document.get("password") as! String
                let isEqual = (password == passwordX)
                let activated = document.get("isActivated") as? Bool
                let watchMode = document.get("watchmode") as! Bool
                let currentHash = document.get("loginID") as? String
                let matchingHash = (currentHash == loginID)
                print("\(currentHash) -> \(loginID) <- test -> \(matchingHash)")
                print("\(isEqual) -> \(password) -> \(passwordX)")
                print("\(activated) <- testing activation test")
               
                if(isEqual)
                {
                    if(activated == true)
                    {
                        
                        print("wtf??")
                        if(!matchingHash)
                        {
                            print("THIS SOHLDN't BE")
                             UserDefaults.standard.set(false, forKey: "LoggedIn")
                            
                            
                            if(MyManager.shared()!.isConnected)
                            {
                                MyManager.shared()?.discClicked = true
                                MyManager.shared()?.disc()
                            }
                            var storyboard = UIStoryboard(name: "Main", bundle: nil)

                            if(UIDevice.current.userInterfaceIdiom == .pad){
                                storyboard = UIStoryboard(name: "Maini", bundle: nil)
                            }
                            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                            
                            destinationViewController.justDisced = true
                            
                            
                            let navigationController = self.window?.rootViewController as! UIViewController
                            
                            navigationController.showDetailViewController(destinationViewController, sender: Any?.self)
                            
                        }
                        
                
                 
                        
                    }
                    else
                    {
                     
                        if(MyManager.shared()!.isConnected)
                        {
                            MyManager.shared()?.discClicked = true
                            MyManager.shared()?.disc()
                        }
                        
                        
                        UserDefaults.standard.set(false, forKey: "LoggedIn")
                    
                        
                        var test = self.window?.rootViewController as! PageViewController
                        
                        
                        test.justDisced = true
                        
           
                        
                        self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        
                        
                    }
                    
                    
                    
                    
                }
                else
                {
                    if(MyManager.shared()!.isConnected)
                    {
                        MyManager.shared()?.discClicked = true
                        MyManager.shared()?.disc()
                    }
                    
                    
                    UserDefaults.standard.set(false, forKey: "LoggedIn")
                    
                    print(" RIGHT HERE.")
                    var test = self.window?.rootViewController as! PageViewController
                    
                    
                    test.justDisced = true
                    self.window?.rootViewController = test
                      self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    
               
                }
            }
            else
            {
                UserDefaults.standard.set(false, forKey: "LoggedIn")
                if(MyManager.shared()!.isConnected)
                {
                    MyManager.shared()?.discClicked = true
                    MyManager.shared()?.disc()
                }
                
                
                UserDefaults.standard.set(false, forKey: "LoggedIn")
                
                print(" RIGHT HERE.")
                
          self.window!.rootViewController?.dismiss(animated: false, completion: nil)
              
            }
            
        }
        }
    }
    
    @objc func sendMessage(msgToSend: UIImage!)
    {
        WCSession.default.sendMessageData(msgToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
        
    }
    
    @objc
    func sendWatchMessage(){
        
        if(!MyManager.shared().watchChanged == false)
        { return }
        if(!WCSession.default.isReachable) { return }
    if(watchBounds == nil) {
    let message = ["alert": "go"]
    
    WCSession.default.sendMessage(message, replyHandler: nil)
    initialDot = true
    }
    else{
    if(MyManager.shared()?.currentPage == DRAWING_MODE || MyManager.shared()?.currentPage == ZONE_GO)
    {
    print("DOING WATCH REDRAW.")
    MyManager.shared()?.rdrawWatch()
    }
    else
    {
    sendInitialDot()
    }
    }
    
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func requestBounds()
    {
        let message = ["alert": "go"]
        
        WCSession.default.sendMessage(message, replyHandler: nil)
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("testttttinggggg.")
  
        print("messsage tst: \(message)")
        print("drwaing mode message test.")
        
     
        if(message == nil) { return }
        
        message.forEach {
           
            switch($0.key as! String)
            {
               
            case "update":
                MyManager.shared()?.rdrawWatch()
                break
            case "save" :
                MyManager.shared()?.doWatchSave()
                break
            case "clear":
                
              MyManager.shared()?.doWatchClear()
                break
                
            case "reset" :
             MyManager.shared()?.doWatchReset()
                
                break
       
            case "alert":
                //  watchBounds = $0.value as! CGRect
                
                print("RECEIVED DOT ALERT.")
                var arrayOfBounds = ($0.value as! String).components(separatedBy: "-")
    
                watchBounds = CGRect(x: 0, y: 0, width: CGFloat((arrayOfBounds[0] as! NSString).floatValue), height: CGFloat((arrayOfBounds[1] as! NSString).floatValue))
               if(initialDot)
               {
                sendInitialDot()
                initialDot = false
                }
                
                break
                
            case "justLaunched":
                print("just launched...")
                if(watchBounds == nil) {
                    let message = ["alert": "go"]
                    
                    WCSession.default.sendMessage(message, replyHandler: nil)
                    initialDot = true
                }
                else{
                    if(MyManager.shared()?.currentPage == DRAWING_MODE || MyManager.shared()?.currentPage == ZONE_GO)
                    {
                     print("DOING WATCH REDRAW.")
                        MyManager.shared()?.rdrawWatch()
                    }
                    else
                    {
                    sendInitialDot()
                    }
                }
               
                break
        
            default:
                    break
        }
    }
    
    }
    
    
    func sendInitialDot()
    {
        var imageToSend = UIImage()
     
        var booleanFar = false
        var superColor = UIColor.white
        
        print("app delegate message test")
        if(watchBounds == nil )
        {
              initialDot = true
            let message = ["alert": "go"]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
          
            print("app delegate - dot not there.")
            return
        }
        
        print("SENDING INITIAL DOT.")
        var outImage = UIImage()
        if(!UserDefaults.standard.bool( forKey: "Watchmode"))
        {
            
            
            
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
            
            
            
            
            var imageToSend = img.overlayWith(image: superImage, posX: 0, posY: watchBounds.height - 45)
            
            WCSession.default.sendMessageData(imageToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
            
            
        
            return
        }
        
        if(UserDefaults.standard.bool( forKey: "Watchmode"))
        {
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: watchBounds.width, height: watchBounds.height))
                let img = renderer.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
    
                
                let renderera = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
                let imgtwo = renderera.image { ctx in
                    
                    
                    if(MyManager.shared().isConnected)
                    {
                        
                        if(MyManager.shared().isCharging)
                        {
                            superColor = UIColor.orange
                            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
                            
                        }
                        else
                        {
                            superColor = UIColor.green
                            ctx.cgContext.setFillColor(UIColor.green.cgColor)
                        }
                        
                    }
                    else
                    {
                        
                        ctx.cgContext.setFillColor(UIColor.red.cgColor)
                        
                        
                        
                    }
                    
                    ctx.cgContext.setLineWidth(5)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: 20, height: 20)
                    ctx.cgContext.addEllipse(in: rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                    
                    
                }
                
                
                
                
                if(!UserDefaults.standard.bool( forKey: "ConnectionStatus"))
                    
                {
                    
                    if(MyManager.shared()!.isConnected)
                   
                    {
                        var label = imageWith(name: "\(MyManager.shared().batteryCharge)%", color: superColor) as! UIImage
                        outImage = img.overlayWith(image: label as! UIImage, posX: 20, posY: watchBounds.height )
                        outImage = outImage.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height)
                    }
                    else
                    {
                        outImage = img.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height)
                    }
                    
                    imageToSend = outImage
                      WCSession.default.sendMessageData(imageToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
                }
                else
                {
                      WCSession.default.sendMessageData(img.pngData() as! Data, replyHandler: nil, errorHandler: nil)
                }
                
            //    imageToSend = img.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height)
                
                
              
                print("SHOULD WORK!!!!")
            }
            
            
            
            
        }
    }

    
@objc
    func returnBluetooth() -> Bool
    {
        print("returnBluetooth ********* cbCentralManager \(String(describing: cbCentralManager))   cbCentralManager.state \(cbCentralManager.state) ")
        if(cbCentralManager != nil)
        {
            /*
             case unknown

             case resetting

             case unsupported

             case unauthorized

             case poweredOff

             case poweredOn
             */
            if(cbCentralManager.state == .poweredOn){
                print("cbCentralManager.state is ON");
            }else if(cbCentralManager.state == .unknown){
                print("cbCentralManager.state is unknown");
            }else if(cbCentralManager.state == .resetting){
                print("cbCentralManager.state is resetting");
            }else if(cbCentralManager.state == .unsupported){
                print("cbCentralManager.state is unsupported");
            }else if(cbCentralManager.state == .unauthorized){
                print("cbCentralManager.state is unauthorized");
            }else if(cbCentralManager.state == .poweredOff){
                print("cbCentralManager.state is poweredOff");
            }
            if(cbCentralManager.state == .poweredOn ) {
                return true }
            else
            {
                return false
            }
        }
        return false
    }
    
    
    //MARK:- didFinishLaunchingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        
        UIApplication.shared.isIdleTimerDisabled = true;


//        cbCentralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
        cbCentralManager = CBCentralManager(delegate: self, queue: .main, options: nil);

        
        if(self.returnBluetooth()){
                       MyManager.shared().isBLEon = true;
        }
        
        
   Bugsnag.start(withApiKey: "233cfed9e828f1ae0d06e42212103a84")
        Bugsnag.notifyError(NSError(domain:"com.example", code:408, userInfo:nil))
            let defaults = UserDefaults.standard
        if FirebaseApp.app() == nil
        {
            FirebaseApp.configure()
        }
        
        var imageToSend = UIImage()
        var booleanFar = false
        var superColor = UIColor.white
        
        var outImage = UIImage()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

    UIApplication.shared.isStatusBarHidden = true
       
  
        
        
        
        if (WCSession.isSupported()) {
            
            session.delegate = self
            session.activate()
            
        
        }
        
       let  timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(sendWatchMessage), userInfo: nil, repeats: true)
        let  timerX = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(checkHash), userInfo: nil, repeats: true)
        
        print("UserDefaults.standard.bool( forKey: LoggedIn) \(UserDefaults.standard.bool( forKey: "LoggedIn"))")
        if(!UserDefaults.standard.bool( forKey: "LoggedIn")) 
        {
        
        if defaults.integer(forKey:"savedCount") == nil {
            defaults.set(0, forKey: "savedCount")
            
           var dictionary: Dictionary = [String: String]()
            
            
            defaults.set(dictionary, forKey: "savedDictionary")
            
            
        }
        
                defaults.set(false, forKey: "InvertColors")
          defaults.set(false, forKey: "DisableVibrations")
       
        
            defaults.set(false, forKey: "AutoSaveOnHome")
        
        
          defaults.set(false, forKey: "ButtonLock")
  
        
            defaults.set(false, forKey:"ShowTemplate")
            
           defaults.set(false, forKey: "HideButtonOverlays")
            
            defaults.set(true, forKey: "DrawingAlwaysVisible")
            
        
             defaults.set( String("\(randomNumber(with: 10))".sha1()), forKey: "loginID")

  
           defaults.set(false, forKey: "AutoSave")
   
            defaults.set(false, forKey: "IncognitoMode")
       
         defaults.set(false, forKey: "ConnectionStatus")
            defaults.set(false, forKey: "Watchmode")
            defaults.set(2, forKey: "lineWidth")
         defaults.set(1, forKey: "rotate")
         defaults.set(5, forKey: "zonevibrates")
            defaults.set(5, forKey: "autoSaveTimer")
            defaults.set(false, forKey: "penSound")
            defaults.set(true, forKey: "penAutoPower")

            
            print("-> just a test -> \(UserDefaults.standard.string( forKey: "loginID") as! String)")
            
        
        }
        
        initialDot = true
       sendInitialDot()
        print("SENT FOR INITIAL DOT.")
        
        
        
        return true
    }

  
  
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        MyManager.shared().stopCheckingPeripheralConnection();
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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
    
    

    
    

    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(!UserDefaults.standard.bool( forKey: "Watchmode"))
        {
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
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
                
                
                
                
                var imageToSend = img.overlayWith(image: superImage, posX: 0, posY: watchBounds.height - 45)
                
                WCSession.default.sendMessageData(imageToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
                
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            if(MyManager.shared().alreadyConnected)
            {
                if(!self.returnBluetooth()){
                    MyManager.shared().alreadyConnected = false;
                    MyManager.shared()?.setNoBluetooth(false)
                }else{
                    MyManager.shared().isBLEon = true;
                    MyManager.shared().startCheckingPeripheralConnection(true)
                }
            }else{
                if(!self.returnBluetooth()){
                    MyManager.shared()?.setNoBluetooth(false)
                }else{
                    MyManager.shared()?.setNoBluetooth(true)
                    MyManager.shared().isBLEon = true;
                }
            }
        }
        
        
        
    }

    
    @objc
    func bluetoothAvailable() -> Bool
    {
        return true
        //return bluejay.isBluetoothAvailable
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if(UserDefaults.standard.bool( forKey: "Watchmode"))
        {
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: watchBounds.width, height: watchBounds.height))
                let img = renderer.image { ctx in
                    ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                    ctx.cgContext.setLineWidth(10)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: watchBounds.width, height: watchBounds.height)
                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
                
                let renderera = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
                let imgtwo = renderera.image { ctx in
                    
                    
             
                        ctx.cgContext.setFillColor(UIColor.red.cgColor)
                        
                    
                    ctx.cgContext.setLineWidth(5)
                    
                    let rectangle = CGRect(x: 0, y: 0, width: 20, height: 20)
                    ctx.cgContext.addEllipse(in: rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                    
                    return
                    
                }
         
                
                var imageToSend = img.overlayWith(image: imgtwo, posX: 0, posY: watchBounds.height)
                
                WCSession.default.sendMessageData(imageToSend.pngData() as! Data, replyHandler: nil, errorHandler: nil)
                
            }
    
    }
    }

}

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
