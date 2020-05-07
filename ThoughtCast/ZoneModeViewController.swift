//
//  ZoneModeViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/17/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import AudioToolbox


class ZoneModeViewController: UIViewController  {
  
    
    @IBOutlet weak var yellowdot: UIImageView!
    @IBOutlet weak var fingerPaintView: FingerPaint!
    var passedIndex: Int!
    var imagetoLoad: Bool?
    var redrawfarPoints: [(point: CGPoint, type: CGPathElementType)] = []
    var imagePassed = UIImage()
    var imagePassedBool = false
   var doUpdate = false
    var passedBack: UIBezierPath!
    @IBOutlet weak var connectionDot: UIImageView!
    @IBOutlet weak var redButton: UIButton!
    var lastButton: UIButton!

    @IBOutlet weak var homeButton: UIButton!
    var watchBounds: CGRect!
    
    @IBOutlet var circleButtons: [UIButton]!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var imageX: UIImage!
    @IBOutlet weak var connectionDotStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var drawViewZoneSetup: DrawView!
    @IBOutlet weak var batteryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
       print("here we are")
       MyManager.shared()?.currentPage = ZONE_SETUP
     
        
        drawViewZoneSetup.currentPage = ZONE_SETUP
        drawViewZoneSetup.INMOVE = false
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("test: \(fileURLs.first?.lastPathComponent)")
            
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        if(imagePassedBool)
        {
            fingerPaintView.image = imagePassed
        }

        let tapAction = UITapGestureRecognizer(target: self, action: #selector(actionTapped(_:)))
        
        batteryLabel?.isUserInteractionEnabled = true
        batteryLabel?.addGestureRecognizer(tapAction)
        connectionDot?.isUserInteractionEnabled = true
        connectionDot?.addGestureRecognizer(tapAction)
        

        
     
        
        

        drawViewZoneSetup.backgroundColor = UIColor.black
        
    }
    

   
    
    
   override func viewDidLayoutSubviews() {
        if  imagetoLoad ?? false
            
        {
            
            
            fingerPaintView.imageToLoad = imageX
            fingerPaintView.iLoad = true
            fingerPaintView.image =  imageX
            fingerPaintView.outSideFrame = fingerPaintView.frame.size
            
            
            drawViewZoneSetup.adjust(TransitionTo: drawViewZoneSetup.frame.size, NewPoints: redrawfarPoints)
            fingerPaintView.first = false
            //            fingerPaintView.load = true
            
            print("yea")
            imagetoLoad = false
        }
    
        if doUpdate == true
        {
                  drawViewZoneSetup.adjust(TransitionTo: drawViewZoneSetup.frame.size, NewPoints: redrawfarPoints)
            doUpdate = false
    }
        
    }
    
    @IBAction func red(_ sender: UIButton) {
      
        
        lastButton.setImage(UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        
        lastButton = sender
        lastButton.tag = 1
        fingerPaintView.drawColor = UIColor.red
        sender.setImage(UIImage(named: "1-Button-Selected"), for: UIControl.State.normal)
    }
    

    
    
    
    override var prefersStatusBarHidden: Bool {
        print("ok!")
        return true
    }
    
    
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        MyManager.shared().zoneDrawView = self
        
        lastButton = redButton
        lastButton.tag = 1
        lastButton.setImage(UIImage(named: "1-Button-Selected"), for: UIControl.State.normal)
        setDot()
        
        print("\(fingerPaintView.frame) +  \(drawViewZoneSetup.frame)")
        
    
   
        fingerPaintView.isUserInteractionEnabled = true
        
        fingerPaintView.frame = self.view.frame
        

        // Do any additional setup after loading the view.
        
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
  

    }
    
    
    @objc func move_began(point Point: CGPoint)
    {
       
    
   //    print("\(fingerPaintView.colorAt(Position: Point))")
       drawViewZoneSetup.move_began(point: Point)
  redrawfarPoints.append((Point, CGPathElementType.moveToPoint))
    }
    
    @objc func move_moved(point Point: CGPoint)
    {
    
     
        
        redrawfarPoints.append((Point, CGPathElementType.addLineToPoint))
        print("wtffx")
    //      print("\(fingerPaintView.colorAt(Position: Point))")
        drawViewZoneSetup.move_moved(point: Point)
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        drawViewZoneSetup.stop()
        drawViewZoneSetup.clear()
        drawViewZoneSetup = nil
        
        
        

 
//        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if(UIDevice.current.userInterfaceIdiom == .pad){
//            storyboard = UIStoryboard(name: "Maini", bundle: nil)
//        }
////        let viewC: ViewController = storyboard.instantiateViewController(withIdentifier: "mainpage") as! ViewController
//        
//        let viewC = storyboard.instantiateViewController(withIdentifier: "mainnavigation")
        
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
   
        self.connectionDot.image = UIImage.init(named: "yellowdot")
        MyManager.shared().refresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
       
            self.setDot()
        }
    }
    
    
    @objc
    func actionTapped(_ sender: UITapGestureRecognizer) {
        if(!UserDefaults.standard.bool(forKey: "DisableVibrations"))
        {
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
            var dotWithLabel: UIImage!
            
            
          
            batteryLabel.text = "\(MyManager.shared()!.batteryCharge)%"
            print("CHANGED")
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
            
            return
        }
        else
        {
                    drawViewZoneSetup.updateDot()
            batteryLabel.text = ""
            connectionDot.image = UIImage.init(named: "reddot")
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Save Zone Setup", message: "Enter the name of the file you'd like to save this zone setup as.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            let image = self.fingerPaintView.image as! UIImage
            
     
            
            var itemCount = UserDefaults.standard.integer(forKey: "savedCount")
             itemCount += 1
            
            var setup = [String:String]()
            
 
         
       
            self.saveImage(imageName: "\(answer.text as! String).saved" , image: image)
            
            UserDefaults.standard.set(itemCount, forKey: "savedCount")
            
            
           
            // do something interesting with "answer" here
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [unowned ac] _ in
            
        }
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        
        present(ac, animated: true)

        
    
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    
    @IBAction func x(_ sender: UIButton) {
      
  
        lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        
        fingerPaintView.drawColor = UIColor.white
        sender.setImage(UIImage(named: "0-Button-Selected"), for: UIControl.State.normal)
        lastButton = sender
        lastButton.tag = 0
        fingerPaintView.drawColor = UIColor.clear
    }
    @IBAction func xButton(_ sender: Any) {
    }
    @IBAction func loadButton(_ sender: UIButton) {

        let sourceSelectorTableViewController = ZoneTemplateViewController()
        let navigationController = UINavigationController(rootViewController: sourceSelectorTableViewController)
        
    //    sourceSelectorTableViewController.pathToPass = drawViewZoneSetup.get_path()
        sourceSelectorTableViewController.redrawfarPoints = self.redrawfarPoints
        
        if(fingerPaintView.image != nil)
        {
        
            sourceSelectorTableViewController.ImageToPass = fingerPaintView.image as! UIImage
        }
            self.present(navigationController, animated: true, completion: nil)
    
    }
    @IBAction func clearButton(_ sender: UIButton) {
        fingerPaintView.clear()
    }
    
    func saveImage(imageName: String, image: UIImage) {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
          //      try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
                
                self.view.makeToast("That name is already in use, please enter a unique name.")
                return
                //
                
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }

    
    
    @IBAction func goButton(_ sender: UIButton) {
  
    
        
        drawViewZoneSetup.clear()
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoneGo") as! ZoneGoViewController
        vc.fingerFrame = fingerPaintView.frame
        vc.paintTemplate = fingerPaintView.image
        vc.paintNil = fingerPaintView.doneClear
      //  vc.pathToDraw = drawViewZoneSetup.get_path()
        vc.redrawfarPoints = self.redrawfarPoints
      //  vc.backgroundTemplate = drawViewZoneSetup.shapshot()
        drawViewZoneSetup.clear()
            drawViewZoneSetup.stop()
        
        drawViewZoneSetup = nil
        self.navigationController?.pushViewController(vc, animated: false);
//        self.present(vc, animated: true, completion: nil)
        
       // UserDefaults.standard.set(pngImage, forKey: "zoneTemplate")
    //    performSegue(withIdentifier: "toZoneGo", sender: sender)
    }
    
    @IBAction func orange(_ sender: UIButton) {
     lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        lastButton = sender
        lastButton.tag = 2
               sender.setImage(UIImage(named: "2-Button-Selected"), for: UIControl.State.normal)
        fingerPaintView.drawColor = UIColor.orange
    }
    @IBAction func yellow(_ sender: UIButton) {

         lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
          lastButton = sender
       
        lastButton.tag = 3
                       sender.setImage(UIImage(named: "3-Button-Selected"), for: UIControl.State.normal)
        fingerPaintView.drawColor = UIColor.yellow
    }
    @IBAction func green(_ sender: UIButton) {
          lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        fingerPaintView.drawColor = UIColor.green
          lastButton = sender
        
                       sender.setImage(UIImage(named: "4-Button-Selected"), for: UIControl.State.normal)
    
        lastButton.tag = 4
        
    }

    @IBAction func blue(_ sender: UIButton) {
        lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        fingerPaintView.drawColor = UIColor.blue
          lastButton = sender
                      sender.setImage(UIImage(named: "6-Button-Selected"), for: UIControl.State.normal)
        
        lastButton.tag = 6
    }
    
    @IBAction func superClear(_ sender: UIButton) {
        fingerPaintView.drawColor = UIColor.clear
        lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        //X-Button-Selected
        sender.setImage(UIImage(named: "X-Button-Selected"), for: UIControl.State.normal)
        
        lastButton = sender as! UIButton
        lastButton.tag = 0
    }
    
 
    
    
    @IBAction func newWhite(_ sender: UIButton) {
        lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        
        fingerPaintView.drawColor = UIColor.white
          sender.setImage(UIImage(named: "9-Button-Selected"), for: UIControl.State.normal)
        lastButton = sender
        lastButton.tag = 9
        
   
    }
   
    @IBAction func cyan(_ sender: UIButton) {
               lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        fingerPaintView.drawColor = UIColor.cyan
                       sender.setImage(UIImage(named: "5-Button-Selected"), for: UIControl.State.normal)
        lastButton = sender
        

        lastButton.tag = 5
    }
    @IBAction func purple(_ sender: UIButton) {
        lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
        
        fingerPaintView.drawColor = UIColor.purple
               sender.setImage(UIImage(named: "7-Button-Selected"), for: UIControl.State.normal)
      
        
         lastButton = sender
          lastButton.tag = 7
    }
    @IBAction func magenta(_ sender: UIButton) {
         lastButton.setImage( UIImage(named: "\(lastButton.tag)"), for: UIControl.State.normal)
                       sender.setImage(UIImage(named: "8-Button-Selected"), for: UIControl.State.normal)
        
        
       
        fingerPaintView.drawColor = UIColor.magenta
          lastButton = sender
        lastButton.tag = 8
     
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
