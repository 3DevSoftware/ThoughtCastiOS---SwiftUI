//
//  ViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/2/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import FirebaseFirestore
import DKPhotoGallery
import Firebase
import PlainPing


class ViewController: UIViewController {
    
    var isButtonInProgress: Bool = false;
    
    @IBOutlet weak var iPhoneSE_Renaming: NSLayoutConstraint!
    
    @IBOutlet weak var labelConnection: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var labelBattery: UILabel!
    
    @IBOutlet weak var imageBrain: UIImageView!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var iPad_Vert_Width: NSLayoutConstraint!
    
    var watchBounds:  CGRect!
    var drawings = SavedDrawings()
    
    @IBOutlet var iPad_Vert: [NSLayoutConstraint]!
    @IBOutlet var iPad_Horiz: [NSLayoutConstraint]!
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet var iPhone_8_Portrait: [NSLayoutConstraint]!
    
    var loadedOnce = false
    
    
    let tNodeviceisselected : String = "No device is selected";
    
    //MARK:- Overrides
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        print("yea")
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            if(UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
                do{
                    try setLandcapemode(true)
                }catch LandscapeError.foundNil(let localizedMessage){
                    print("ERROR: \(localizedMessage)")
                }catch {
                    print("ERROR: \(error.localizedDescription)")
                }
                
            }else{
                do{
                    try setLandcapemode(false)
                }catch LandscapeError.foundNil(let localizedMessage){
                    print("ERROR: \(localizedMessage)")
                    
                }catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
            
        }
        
    }
    
    

    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        MyManager.shared().currentPage = FRONT_PAGE
        
        
        print("makes no sense?")
        
        self.connectButton?.layer.borderColor = UIColor.white.cgColor
        self.connectButton?.layer.borderWidth = 1.0
        self.connectButton?.addTarget(self, action: #selector(selectSlate(_:)), for: .touchUpInside);
        
        MyManager.shared().renamingSlate = false
        
        
        
        loadDrawings()
        
        
        
        
    
        
        MyManager.shared().mainPage = self
        
        
        
        drawPage()
        
        
        
        
     
        
        
        /*
         
         */
        
        //       performSegue(withIdentifier: "walkthrough", sender: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    @IBAction func ZoneMode(_ sender: UIButton) {
        if(MyManager.shared().renamingSlate)
        {
            return
        }
        
        if !MyManager.shared().isConnected
            
        {
            switch(UserDefaults.standard.integer(forKey: "selectedDevice")){
            case 1:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a Sensor Board to enter zone mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break;
            case 2:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a  Scribe Pen to enter zone mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break
            default:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a Device to enter zone mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break
            }
            
            return
        }
        
        
        // if MyManager.shared().isConnected
        // {
        

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoneMode") as! ZoneModeViewController

        self.navigationController?.pushViewController(vc, animated: false);
        
//        self.present(vc, animated: false, completion: nil)
        
        //  }
        // else
        // {
        //    UIAlertView.init(title: "Not Connected", message: "You must be connected to a Sensorboard to enter zone mode.", delegate: nil, cancelButtonTitle: "Ok").show()
        //}
        
        
        
        
    }
    
    
    
    override func viewWillLayoutSubviews() {

        
        
//        if UIDevice.current.userInterfaceIdiom == .pad
//        {
//
//
//            if(self.view.frame.size.width > self.view.frame.size.height)
//            {
//                print("wtfff")
//                outerStackView.axis = .horizontal
//                NSLayoutConstraint.activate(iPad_Horiz)
//                NSLayoutConstraint.deactivate(iPad_Vert)
//            }
//            else
//            {
//                print("why")
//                outerStackView.axis = .vertical
//                NSLayoutConstraint.activate(iPad_Horiz)
//                NSLayoutConstraint.deactivate(iPad_Vert)
//                NSLayoutConstraint.activate(iPad_Vert)
//                NSLayoutConstraint.deactivate(iPad_Horiz)
//            }
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        isButtonInProgress = false;
        drawPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isButtonInProgress = false;
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        if MyManager.shared().isConnected && !MyManager.shared().renamingSlate
        {
            showInputDialog(title: "Rename Sensor Board",
                            subtitle: "Please enter the new name for the sensor board below.",
                            actionTitle: "Rename",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "New Name",
                            inputKeyboardType: .asciiCapable)
            { (input:String?) in
                
                
                if(input!.count > 8)
                {
                    let alertController = UIAlertController(title: "Error", message:
                        "New name must have 8 characters or less.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                    MyManager.shared().deviceName = input as! NSString
                    print("REnaming to: \(input as! String)")
                    MyManager.shared().renameSlate(input as! String)
                    MyManager.shared().renamingSlate = true
                    MyManager.shared().renameTo = input as! String
                    self.drawPage()
                }
            }
        }
        
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        if MyManager.shared().isConnected && !MyManager.shared().renamingSlate
        {
            showInputDialog(title: "Rename Sensor Board",
                            subtitle: "Please enter the new name for the sensor board below",
                            actionTitle: "Rename",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "New Name",
                            inputKeyboardType: .asciiCapable)
            { (input:String?) in
                
                
                if(input!.count > 8)
                {
                    let alertController = UIAlertController(title: "Error", message:
                        "New name must have 8 characters or less.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                    MyManager.shared().deviceName = input as! NSString
                    
                    MyManager.shared().renameSlate(input)
                    MyManager.shared().renamingSlate = true
                    MyManager.shared().renameTo = input
                    self.drawPage()
                }
            }
        }
        
    }
    
    
    @IBAction func Instructions(_ sender: UIButton) {
        if(MyManager.shared().renamingSlate)
        {
            return
        }
        
        if let url = URL(string: "http://www.thoughtcastapp.com/iosinstructions") {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    func setDrawings (drawings: [SavedDrawing]){
        DispatchQueue.main.async {
            self.drawings.collection = drawings
            
            
        }
    }
    func loadDrawings() {
        drawings.collection = []
        let album = CustomPhotoAlbum()
        
        
        album.loadSavedDrawings(setDrawings, errorHandler: showErrorAlert)
    }
    
    @IBAction func saved(_ sender: UIButton) {
        if(MyManager.shared().renamingSlate)
        {
            return
        }
        
        
        
        
        performSegue(withIdentifier: "savedDrawings", sender: self)
        print("little test: \(drawings.collection.count)")
        
        
    }
    
    //MARK:- hash
    func checkHash(doNew: Bool = false)
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
        
        if(!(dateTimeComponents.minute! == 00  || dateTimeComponents.minute! == 15 || dateTimeComponents.minute! == 30  || dateTimeComponents.minute! == 45 || doNew)) { return }
        
        var button = true
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
                let activedevice = document.get("activedevices") as! NSDictionary
                let neopen = activedevice["neoPen"];
                let isknSlate = activedevice["isknSlate"];
                let matchingHash = (currentHash == loginID)
                
                UserDefaults.standard.set(neopen, forKey: "neoPen")
                UserDefaults.standard.set(isknSlate, forKey: "isknSlate")
                UserDefaults.standard.synchronize()
                
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
                            
                            
                            print("set to false.")
                            
                            let dialogMessage = UIAlertController(title: "Error", message: "Another device is logged in on this account, visit thoughtcastapp.com/owners to reset activations.", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                self.performSegue(withIdentifier: "toBegin", sender: nil)
                                
                                button = false
                                
                            })
                            
                            
                            
                            
                            //Add OK and Cancel button to dialog message
                            dialogMessage.addAction(ok)
                            self.present(dialogMessage, animated: true, completion: nil)
                            while(button) { }
                            
                            
                            
                            
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
                        
                        let dialogMessage = UIAlertController(title: "Error", message: "Another device is logged in on this account, visit thoughtcastapp.com/owners to reset activations.", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            self.performSegue(withIdentifier: "toBegin", sender: nil)
                            
                            button = false
                            
                        })
                        
                        
                        
                        
                        //Add OK and Cancel button to dialog message
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                        while(button) { }
                        
                        
                        
                        
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
                    
                    self.performSegue(withIdentifier: "toBegin", sender: nil)
                    
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
                
                self.performSegue(withIdentifier: "toBegin", sender: nil)
                
                
                
            }
            
        }
    }
    
  
    
    
    
    
    func showDialog()
        
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // your code here
        }
        
    }
    
    
    @objc func selectSlate(_ sender: UIButton) {
        
        if(connectButton.currentTitle == tNodeviceisselected){
            let alertSelectDevice : UIAlertController = UIAlertController(title: "Select a device", message: "To continue please select a device in settings", preferredStyle: .alert)
            let actionSelectDevice : UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            alertSelectDevice.addAction(actionSelectDevice);
            self.present(alertSelectDevice, animated: true, completion: nil);
            return;
        }
        if(!isButtonInProgress){
            isButtonInProgress = true;
            UIApplication.shared.statusBarStyle = .lightContent
            UIApplication.shared.isStatusBarHidden = true
            
            if Reachability.isConnectedToNetwork()
            {
                PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                    if let latency = timeElapsed {
                        if(latency <= 80.0)
                        {
                            self.checkNowWithGoodSpeed();
                        }else{
                            self.checkNowWithLowSpeed();
                        }
                    }
                    if let error = error {
                        self.checkNowWithLowSpeed();
                    }
                })
            }else{
                checkNowWithLowSpeed();
            }
        }
       
        
    }
    
    
    
    //Checks
    func checkNowWithGoodSpeed(){

        print("Internet Connection Available!")
        
        
        
        checkHash(doNew: true)
        
        print("CHECKED HASH.")
        let loggedInX = UserDefaults.standard.bool(forKey: "LoggedIn")
        if(!loggedInX)
        { return }
        
        print("\(loggedInX) <- login bool")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(UserDefaults.standard.string(forKey: "loggedInAs") as! String)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {

                let password = document.get("password") as! String
                let isEqual = (password == UserDefaults.standard.string(forKey: "Password") as! String)
                let activated = document.get("isActivated") as! Bool
                let watchMode = document.get("watchmode") as! Bool
                let activedevice = document.get("activedevices") as! NSDictionary
                let neopen = activedevice["neoPen"];
                let isknSlate = activedevice["isknSlate"];

                if(isEqual)
                {

                    if(watchMode)
                    {
                        UserDefaults.standard.set(true, forKey: "Watchmode")
                        // log out
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "Watchmode")
                    }
                    
                    UserDefaults.standard.set(neopen, forKey: "neoPen")
                    UserDefaults.standard.set(isknSlate, forKey: "isknSlate")
                    UserDefaults.standard.synchronize()

                    if(!activated)
                    {
                        
                        UserDefaults.standard.set(false, forKey: "LoggedIn")
                        print("not activated")
                        
                        let dialogMessage = UIAlertController(title: "Error", message: "Your account is no longer active for this instance of ThoughtCast.", preferredStyle: .alert)
                        
                        if(MyManager.shared()!.isConnected)
                        {
                            MyManager.shared()?.discClicked = true
                            MyManager.shared()?.disc()
                        }
                        
                        
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        })
                        
                        
                        
                        //Add OK and Cancel button to dialog message
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                        
                        if(MyManager.shared().isConnected || MyManager.shared().renamingSlate)
                        {
                            MyManager.shared().discClicked = true
                            MyManager.shared().renamingSlate = false
                            
                            MyManager.shared().isLooking = false
                            if(UserDefaults.standard.integer(forKey: "selectedDevice") == 2){
                                Neo.shared().disconnectPen()
                            }else{
                                disconnect()
                                MyManager.shared().stopCheckingPeripheralConnection()
                            }
                            self.labelConnection?.textColor = UIColor.red
                            self.labelConnection?.text = "Disconnected"
                            
                        }
                        if(MyManager.shared()!.isConnected)
                        {
                            MyManager.shared()?.discClicked = true
                            MyManager.shared()?.disc()
                        }
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                        
                        self.present(vc, animated: true, completion: nil)
                        
                        return
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
                    
                    
                    // add an action (button)
                    let dialogMessage = UIAlertController(title: "Error", message: "Your password has changed, please re-login.", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    })
                    
                    
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    
                    if(MyManager.shared().isConnected || MyManager.shared().renamingSlate)
                    {
                        MyManager.shared().renamingSlate = false
                        MyManager.shared().discClicked = true
                        if(UserDefaults.standard.integer(forKey: "selectedDevice") == 2){
                            Neo.shared().disconnectPen()
                        }else{
                            disconnect()
                            MyManager.shared().stopCheckingPeripheralConnection()
                        }
                        MyManager.shared().isLooking = false
                    }
                    if(MyManager.shared()!.isConnected)
                    {

                        MyManager.shared()?.discClicked = true
                        MyManager.shared()?.disc()
                    }
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                    
                    self.present(vc, animated: true, completion: nil)
                    
                    return
                }
                
                
            } else {
                

                
                let dialogMessage = UIAlertController(title: "Error", message: "Your account no longer exists and you are logged out.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough") as! PageViewController
                    UserDefaults.standard.set(false, forKey: "LoggedIn")
                    if(MyManager.shared().isConnected)
                    {
                        MyManager.shared().discClicked = true
                        MyManager.shared().isLooking = false
                        if(UserDefaults.standard.integer(forKey: "selectedDevice") == 2){
                            Neo.shared().disconnectPen()
                            self.drawPage()
                        }else{
                            disconnect()
                            MyManager.shared().stopCheckingPeripheralConnection()
                            self.drawPage()
                        }                    }
                    print("hrmm not wroking is a lie")
                    self.present(vc, animated: true, completion: nil)
                    
                    
                })
                
                
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                
                
                
                return
            }
            if MyManager.shared().isConnected || MyManager.shared().isLooking || MyManager.shared().renamingSlate
            {
                self.isButtonInProgress = false;
                print("yes.... connnected, clicked disconnect")
                MyManager.shared().renamingSlate = false
                MyManager.shared().discClicked = true
                MyManager.shared().isLooking = false
                if(UserDefaults.standard.integer(forKey: "selectedDevice") == 2){
                    Neo.shared().disconnectPen()
                    self.drawPage()
                }else{
                    disconnect()
                    MyManager.shared().stopCheckingPeripheralConnection()
                    self.drawPage()
                }
                
            }
            else
            {

                print("MyManager.shared().isBLEon \(MyManager.shared().isBLEon)")
                if MyManager.shared().isBLEon {
                    if UserDefaults.standard.integer(forKey: "selectedDevice") == 2
                    {
                        let neo : Neo = Neo.shared()
                        neo.getReady()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            neo.startPen()
                            self.isButtonInProgress = false;
                        }
                        
                    }else{
                        self.performSegue(withIdentifier: "selectslate", sender: self);
                    }
                }else{
                    let alert : UIAlertController = UIAlertController(title: "ERROR", message: "Please Turn on Bluetooth to connect", preferredStyle: .alert)
                    let action : UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        self.isButtonInProgress = false;
                    })
                    alert.addAction(action);
                    self.present(alert, animated: true, completion: nil);
                }
                
//                let story = UIStoryboard(name: "Main", bundle: nil)
//                let vc = story.instantiateViewController(withIdentifier: "selectSlate") as! SelectSlateTableViewController
//                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
        }

    }
    
    func checkNowWithLowSpeed(){
        print("SKiPPED FOR SOME REASON")
        

        if MyManager.shared().isConnected || MyManager.shared().isLooking || MyManager.shared().renamingSlate
        {
            self.isButtonInProgress = false;
            print("here detected.")
            MyManager.shared().discClicked = true
            MyManager.shared()?.renamingSlate = false
            
            MyManager.shared().isLooking = false
            
            if(UserDefaults.standard.integer(forKey: "selectedDevice") == 2){
                Neo.shared().disconnectPen()
                self.drawPage()
            }else{
                disconnect()
                MyManager.shared().stopCheckingPeripheralConnection()
                self.drawPage()
            }
            
        }
        else
        {
            if MyManager.shared().isBLEon {
                if UserDefaults.standard.integer(forKey: "selectedDevice") == 2
                {
                    let neo : Neo = Neo.shared()
                    neo.getReady()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        neo.startPen()
                        self.isButtonInProgress = false;
                    }
                }else{
                    self.performSegue(withIdentifier: "selectslate", sender: self);
                }
            }else{
                let alert : UIAlertController = UIAlertController(title: "ERROR", message: "Please Turn on Bluetooth to connect", preferredStyle: .alert)
                let action : UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.isButtonInProgress = false;
                })
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            }

//            let story = UIStoryboard(name: "Main", bundle: nil)
//            let vc = story.instantiateViewController(withIdentifier: "selectSlate") as! SelectSlateTableViewController
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    
    func imageWith(name: String?, color: UIColor) -> UIImage? {
        let text = name as! String
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        let textSize = text.size(withAttributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
        let rect = CGRect(origin: .zero, size: textSize)
        text.draw(with: rect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    
    
    @IBAction func DrawingMode(_ sender: UIButton) {
        if(MyManager.shared().renamingSlate)
        {
            return
        }
        
        
        if MyManager.shared().isConnected
        {
            self.performSegue(withIdentifier: "drawingmode", sender: self)
    
        }
        else
        {
            switch(UserDefaults.standard.integer(forKey: "selectedDevice")){
            case 1:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a Sensor Board to enter drawing mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break;
            case 2:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a  Scribe Pen to enter drawing mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break
            default:
                UIAlertView.init(title: "Not Connected", message: "You must be connected to a Device to enter drawing mode.", delegate: nil, cancelButtonTitle: "Ok").show()
                break
            }
        }
    }
    
    @IBAction func Settings(_ sender: UIButton) {
        
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            checkHash(doNew: true)
            
            
        }
        
        if(MyManager.shared().renamingSlate)
        {
            return
        }
        
        let topicsList = SettingTableViewController()
        let topicsListNavContrl = UINavigationController(rootViewController: topicsList)
        
        performSegue(withIdentifier: "Settings", sender: nil)
        
    }
    
    @objc func drawPage()
    {
        let XappDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        XappDelegate?.sendInitialDot()
        
        let messageZ = ["doUpdate": "go"]
//        var greet4Height = self.labelConnection.optimalHeight
        
//        self.labelConnection.frame = CGRect(x: self.labelConnection.frame.origin.x, y: self.labelConnection.frame.origin.y, width: self.labelConnection.frame.width, height: greet4Height)
        print("hmm.....wtf?! \(MyManager.shared().currentPage) + \(FRONT_PAGE.rawValue)")
        if MyManager.shared().currentPage == FRONT_PAGE
        {
            
            if MyManager.shared().renamingSlate
            {
                self.labelConnection.startBlink()
                self.labelConnection?.textColor = UIColor.white
                
                
                
                var renameBounds = CGRect(x: labelConnection.frame.origin.x, y: labelConnection.frame.origin.y, width: labelConnection.bounds.width + 20, height: labelConnection.bounds.height + 35 )
                
                
                renameButton.frame = renameBounds
                
                
                self.labelConnection?.text = "Renaming..."
//                var greet4Height = self.labelConnection.optimalHeight
                
//                self.labelConnection.frame = CGRect(x: self.labelConnection.frame.origin.x, y: self.labelConnection.frame.origin.y, width: self.labelConnection.frame.width, height: greet4Height)
                labelBattery.isHidden = true
                return
                
            }
            else
            {
                
                self.labelConnection.stopBlink()
                
                var renameBounds = CGRect(x: labelConnection.frame.origin.x, y: labelConnection.frame.origin.y, width: labelConnection.bounds.width + 20, height: labelConnection.bounds.height + 35 )
                
                
                renameButton.frame = renameBounds
            }
            
            print("TEST: \(MyManager.shared().isLooking) || \(MyManager.shared().isConnected) || \(MyManager.shared()?.getString())")
            if MyManager.shared().isConnected
            {
                
                
                
                var renameBounds = CGRect(x: labelConnection.frame.origin.x, y: labelConnection.frame.origin.y, width: labelConnection.bounds.width + 20, height: labelConnection.bounds.height + 35 )
                
                
                renameButton.frame = renameBounds
                
                
                
                
                DispatchQueue.main.async {
                    
                    self.labelConnection?.textColor = UIColor.green
                }
                if(MyManager.shared().deviceName != nil)
                {
                    DispatchQueue.main.async {
                        
                        self.labelConnection?.text = "Connected to: \(MyManager.shared().deviceName!)"
                    }
                    DispatchQueue.main.async {
                        if MyManager.shared().isCharging {
                            self.labelBattery.text = "Charging - Battery: \(MyManager.shared().batteryCharge)%"
                        }
                        else {
                            self.labelBattery.text = "Battery: \(MyManager.shared().batteryCharge)%"
                        }
                    }
                    print("Test \(MyManager.shared().isCharging)")
                    DispatchQueue.main.async {
                        self.labelBattery.isHidden = false
                    }
                    if MyManager.shared().batteryCharge > 20 && !(MyManager.shared().isCharging)
                    {
                        labelBattery.textColor = UIColor.green
                    }
                    else if MyManager.shared().isCharging
                    {
                        print("wtf??")
                        DispatchQueue.main.async { // Correct
                            
                            self.labelConnection?.text = "Connected to: \(MyManager.shared().deviceName!) "
                            self.labelConnection?.textColor = UIColor.orange
                        }
                        
                        labelBattery.textColor = UIColor.orange
                    }
                    else
                    {
                        labelBattery.textColor = UIColor.red
                    }
                    
                    
                }
                else
                {
                    self.labelConnection?.text = "Connecting..."
                }
                
                
                DispatchQueue.main.async {
                    if UserDefaults.standard.integer(forKey: "selectedDevice") == 2
                    {
                        self.connectButton?.setTitle("Disconnect Scribe Pen", for: UIButton.State.normal)

                    }else{
                        self.connectButton?.setTitle("Disconnect Sensor Board", for: UIButton.State.normal)
                    }
                }
                return
            }
            else
            {
                
            
                
                
                print("so not connected..")
                
                if MyManager.shared().isLooking
                {
                    self.labelConnection?.textColor = UIColor.orange
                    self.labelConnection?.text = "Looking for: \(MyManager.shared().deviceName!)"
                    if UserDefaults.standard.integer(forKey: "selectedDevice") == 2
                    {
                        self.connectButton?.setTitle("Disconnect Scribe Pen", for: UIButton.State.normal)
                        
                    }else{
                        self.connectButton?.setTitle("Disconnect Sensor Board", for: UIButton.State.normal)
                    }
                    labelBattery.isHidden = true
                    self.labelConnection.stopBlink()
                    return
                    
                    
                }
                else
                {
                    if !MyManager.shared().isBLEon {
                        DispatchQueue.main.async { // Correct
                            
                            self.labelConnection?.textColor = UIColor.red
                            self.labelConnection?.text = "Bluetooth is off"
                            self.labelBattery.isHidden = true
                            
                            switch(UserDefaults.standard.integer(forKey: "selectedDevice")){
                            case 1:
                                if(UserDefaults.standard.bool(forKey: "isknSlate")){
                                    self.connectButton?.setTitle("Connect to Sensor Board", for: UIButton.State.normal)
                                }else{
                                    self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                    UserDefaults.standard.set(0, forKey: "selectedDevice")
                                    UserDefaults.standard.synchronize()
                                }
                                break;
                            case 2:
                                if(UserDefaults.standard.bool(forKey: "neoPen")){
                                    self.connectButton?.setTitle("Connect to Scribe Pen", for: UIButton.State.normal)
                                }else{
                                    self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                    UserDefaults.standard.set(0, forKey: "selectedDevice")
                                    UserDefaults.standard.synchronize()
                                }
                                break
                            default:
                                self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                break
                            }
                            
//                            self.connectButton?.setTitle("Connect to Sensor Board", for: UIButton.State.normal)
                        }
                    }else{
                        DispatchQueue.main.async { // Correct
                            self.labelConnection?.textColor = UIColor.red
                            self.labelConnection?.text = "Disconnected"
                            self.labelBattery.isHidden = true
                            switch(UserDefaults.standard.integer(forKey: "selectedDevice")){
                            case 1:
                                if(UserDefaults.standard.bool(forKey: "isknSlate")){
                                    self.connectButton?.setTitle("Connect to Sensor Board", for: UIButton.State.normal)
                                }else{
                                    self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                    UserDefaults.standard.set(0, forKey: "selectedDevice")
                                    UserDefaults.standard.synchronize()
                                }
                                break;
                            case 2:
                                if(UserDefaults.standard.bool(forKey: "neoPen")){
                                    self.connectButton?.setTitle("Connect to Scribe Pen", for: UIButton.State.normal)
                                }else{
                                    self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                    UserDefaults.standard.set(0, forKey: "selectedDevice")
                                    UserDefaults.standard.synchronize()
                                }
                                break
                            default:
                                self.connectButton?.setTitle(self.tNodeviceisselected, for: UIButton.State.normal)
                                break
                            }
//                            self.connectButton?.setTitle("Connect to Sensor Board", for: UIButton.State.normal)
                        }
                    }
                   
                }
                
            }
            
            
        }
    }
    
    
    //MARK:-
    enum LandscapeError: Error {
        case foundNil(_description: String)
    }
    
    @IBOutlet weak var p1: NSLayoutConstraint!
    @IBOutlet weak var p2: NSLayoutConstraint!
    @IBOutlet weak var l1: NSLayoutConstraint!
    @IBOutlet weak var l2: NSLayoutConstraint!
    @IBOutlet weak var p3: NSLayoutConstraint!
    @IBOutlet weak var l3: NSLayoutConstraint!
    @IBOutlet weak var p4: NSLayoutConstraint!
    @IBOutlet weak var p5: NSLayoutConstraint!
    @IBOutlet weak var p6: NSLayoutConstraint!
    @IBOutlet weak var l4: NSLayoutConstraint!
    @IBOutlet weak var l5: NSLayoutConstraint!
    @IBOutlet weak var l6: NSLayoutConstraint!
    @IBOutlet weak var l7: NSLayoutConstraint!
    @IBOutlet weak var p7: NSLayoutConstraint!
    @IBOutlet weak var l8: NSLayoutConstraint!
    @IBOutlet weak var p8: NSLayoutConstraint!
    
    // MARK:- 
    func setLandcapemode(_ mode : Bool) throws {
        guard p1 != nil || p2 != nil || p3 != nil || p4 != nil || p5 != nil || p6 != nil || p7 != nil || p8 != nil || l1 != nil || l2 != nil || l3 != nil || l4 != nil || l5 != nil || l6 != nil || l7 != nil || l8 != nil  else {
            throw LandscapeError.foundNil(_description: "Found Nil")
        }
        p1.isActive = !mode
        p2.isActive = !mode
        p3.isActive = !mode
        p4.isActive = !mode
        p5.isActive = !mode
        p6.isActive = !mode
        p7.isActive = !mode
        p8.isActive = !mode
        l1.isActive = mode
        l2.isActive = mode
        l3.isActive = mode
        l4.isActive = mode
        l5.isActive = mode
        l6.isActive = mode
        l7.isActive = mode
        l8.isActive = mode
        self.view.layoutIfNeeded()
    }
    

}

//@IBDesignable extension UIButton {
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}


extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }

    func stopBlink() {


        DispatchQueue.main.async {

            self.layer.removeAllAnimations()
            self.alpha = 1
        }
    }
}


//extension UILabel {
//    var optimalHeight : CGFloat {
//        get
//        {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
//            label.numberOfLines = 0
//            label.lineBreakMode = NSLineBreakMode.byWordWrapping
//            label.font = self.font
//            label.text = self.text
//            label.sizeToFit()
//            return label.frame.height
//        }
//
//    }
//}
