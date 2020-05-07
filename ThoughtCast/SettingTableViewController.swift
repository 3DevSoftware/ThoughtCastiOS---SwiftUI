//
//  SettingTableViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/3/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//



import UIKit
import Firebase



class SettingTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    
//    @IBOutlet weak var devicePV: UIPickerView!
    @IBOutlet weak var switchPenSound: UISwitch!
    @IBOutlet weak var switchPenAutoPower: UISwitch!
    @IBOutlet weak var penAutoPowerLb: UILabel!
    @IBOutlet weak var penSoundLb: UILabel!
    @IBOutlet weak var penSensorpressuretuningLb: UILabel!
    @IBOutlet weak var inputPenPressureTf: UITextField!
    
    @IBOutlet weak var inputDeviceSelectionTf: UITextField!
    
    var penSensorPressurePv = UIPickerView()
    var deviceSelectionPV = UIPickerView()
    
    
    let devicenames : Array = ["Select a device", "Pro/Slate", "Scribe"];
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("hmmm - CANCELLED")
       UserDefaults.standard.set(false, forKey: "IncognitoMode")
        imagePicker.dismiss(animated: false, completion: nil)
             switchIncognitoMode.isOn = false
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("ok!!!!")
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = documentsPath?.appendingPathComponent("image.jpg")
     
        // extract image from the picker and save it
        if var pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            pickedImage = pickedImage.fixOrientation()
    
            try! pickedImage.jpegData(compressionQuality: 1.0)?.write(to: imagePath!)
            
        }
       // SettingsManager.shared.incognitoImage = imagePath
        UserDefaults.standard.set(imagePath, forKey: "incognitoImage")
    
        incognitoThumbNail.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
 
        incognitoThumbNail.isHidden = false
      //  buttonSelectImage.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        UserDefaults.standard.set(true, forKey: "IncognitoMode")
        switchIncognitoMode.isOn = true
        dismiss(animated: true, completion: nil)
    }
    
  

    @IBAction func pickImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
DispatchQueue.main.async {
        self.present(self.imagePicker, animated: true, completion: nil)
        }
        
    
    
    }
    
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 1)
        {
            return 4
        }
        else if(pickerView.tag == 2)
        {
            return 10
        }
        else if(pickerView.tag == 3)
        {
            return 15
        }
        else if(pickerView.tag == 11){
            return devicenames.count;
        }else if(pickerView.tag == 12){
            return 5;
        }else if(pickerView.tag == 14){
            return devicenames.count;
        }
        return 1
    }
    
/*
 @IBOutlet weak var switchInvertColors: UISwitch!
 @IBOutlet weak var switchDisableVibrations: UISwitch!
 @IBOutlet weak var switchAutoSaveOnHome: UISwitch!
 @IBOutlet weak var switchButtonOverlays: UISwitch!
 @IBOutlet weak var switchButtonLock: UISwitch!
 @IBOutlet weak var switchDrawingAlwaysVisible: UISwitch!
 @IBOutlet weak var switchEnableAutoSave: UISwitch!
 @IBOutlet weak var switchIncognitoMode: UISwitch!
 @IBOutlet weak var switchShowTemplate: UISwitch!
 @IBOutlet weak var switchHideConnectionStatusDot: UISwitch!
 */
    
    @IBOutlet weak var drawingAlwaysVisibleCell: UISwitch!
    @IBOutlet weak var switchInvertColors: UISwitch!
    @IBOutlet weak var switchDisableVibrations: UISwitch!
    
    let imagePicker = UIImagePickerController()
    let username = UserDefaults.standard.string(forKey: "loggedInAs")!
    
    @IBOutlet weak var switchAutoSaveOnHome: UISwitch!
    
    @IBOutlet weak var switchButtonOverlays: UISwitch!
    @IBOutlet weak var switchButtonLock: UISwitch!

    @IBOutlet weak var switchDrawingAlwaysVisible: UISwitch!
    
    @IBOutlet weak var incognitoThumbNail: UIImageView!
    
    @IBOutlet weak var lineWidth: UISlider!
    
    
    @IBOutlet weak var switchEnableAutoSave: UISwitch!
    @IBOutlet weak var switchIncognitoMode: UISwitch!
    
    @IBOutlet weak var slideCell: UITableViewCell!
    @IBOutlet weak var switchShowTemplate: UISwitch!
  
    @IBOutlet weak var textRotate: UITextField!
    @IBOutlet weak var switchHideConnectionStatusDot: UISwitch!
    
    @IBOutlet weak var buttonSelectImage: UIButton!
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var textZoneVibrate: UITextField!
    
    @IBOutlet weak var versionLabel: UILabel!
    var rotatesensorboard = UIPickerView()
    var zonevibrates = UIPickerView()
    var autoSaveTimer = UIPickerView()

    
    @IBOutlet weak var textAutoSave: UITextField!
    
    private var dismissViewTap: UITapGestureRecognizer?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 14 { //if pickerView.tag == 11 {
            if(areConnected(pen: nil)){
                let alert : UIAlertController = UIAlertController(title: "Error", message: "You are still connected to a device. Please desconnect before selecting other device", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil);
//                devicePV.selectRow(UserDefaults.standard.integer(forKey: "selectedDevice"), inComponent: 0, animated: false)
                deviceSelectionPV.selectRow(UserDefaults.standard.integer(forKey: "selectedDevice"), inComponent: 0, animated: false)
                return;
            }
            setNeoPenActive(_active: false)
        }
        if pickerView.tag == 1
        {
            UserDefaults.standard.set(row+1, forKey: "rotate")
            
            let defaults = UserDefaults.standard
            defaults.set(row, forKey: "pickerViewRow1")
            
            
            let count = row+1
            
            switch count
            {
            case 1:
                textRotate.text = "0°"
                break;
            case 2:
                textRotate.text = "90°"
                break;
            case 3:
                textRotate.text = "-90°"
                break;
            case 4:
                textRotate.text = "180°"
                break;
            default:
                textRotate.text = "0°"
                break;
            }
            
            
       
        }
        else if pickerView.tag == 2
        {
            let defaults = UserDefaults.standard
            defaults.set(row, forKey: "pickerViewRow2")
            
            
            UserDefaults.standard.set(row+1, forKey: "zonevibrates")
            if row+1 == 1
            {
                textZoneVibrate.text = "\(row+1) time"
            }
            
            
            else {
            textZoneVibrate.text = "\(row+1) times"
       
            }
            
            print(" ok: \(row+1)")
            
        }
        else if pickerView.tag == 3
        {
            let defaults = UserDefaults.standard
            defaults.set(row, forKey: "pickerViewRow3")
            
            UserDefaults.standard.set(row+1, forKey: "autoSaveTimer")
            textAutoSave.text = "\(row+1) seconds"
           
        }
        else if pickerView.tag == 11
        {
//            if(row == 2){
//                if(UserDefaults.standard.bool(forKey: "neoPen")){
//                    UserDefaults.standard.set(row, forKey: "selectedDevice")
//                    UserDefaults.standard.synchronize()
//                    setNeoPenActive(_active: true)
//                }else{
//                    setNeoPenActive(_active: false)
//                    devicePV.selectRow(row-1, inComponent: 0, animated: true)
//                }
//            }else{
//                UserDefaults.standard.set(row, forKey: "selectedDevice")
//                UserDefaults.standard.synchronize()
//            }
           
        }else if pickerView.tag == 12
        {
            UserDefaults.standard.set(row+1, forKey: "penPressure")
            UserDefaults.standard.synchronize()
            setPenPressure(row+1);
            
            let count = row+1
            if(count == 5){
                inputPenPressureTf.text = "Level 5"

            }else{
                inputPenPressureTf.text = getPressure(pressure: count)

            }
            
            
            
        }else if pickerView.tag == 14 {
            if(row == 1){
                if(UserDefaults.standard.bool(forKey: "isknSlate")){
                    UserDefaults.standard.set(row, forKey: "selectedDevice")
                    UserDefaults.standard.synchronize()
                    inputDeviceSelectionTf.text = devicenames[row];
                    setNeoPenActive(_active: false)
                }else{
                    setNeoPenActive(_active: false)
                    deviceSelectionPV.selectRow(row-1, inComponent: 0, animated: true)
                    inputDeviceSelectionTf.text = devicenames[row-1];
                }
            }else if(row == 2){
                if(UserDefaults.standard.bool(forKey: "neoPen")){
                    UserDefaults.standard.set(row, forKey: "selectedDevice")
                    UserDefaults.standard.synchronize()
                    setNeoPenActive(_active: true)
                    inputDeviceSelectionTf.text = devicenames[row];
                }else{
                    setNeoPenActive(_active: false)
                    deviceSelectionPV.selectRow(row-1, inComponent: 0, animated: true)
                    inputDeviceSelectionTf.text = devicenames[row-1];
                }
            }else{
                UserDefaults.standard.set(row, forKey: "selectedDevice")
                UserDefaults.standard.synchronize()
                inputDeviceSelectionTf.text = devicenames[row];
                setNeoPenActive(_active: false)
            }
        }
    }
    
    
    

    func getDegrees(degree Degrees:Int) -> String
    {
        
        switch Degrees
        {
        case 1:
            return "0°"
            break;
        case 2:
            return "90°"
            break;
        case 3:
            return "-90°"
            break;
        case 4:
            return "180°"
            break;
        default:
            return "0°"
            break;
        }
    }
    
    //MARK: - NEO
    func applyPenSettings(_ soundPen : Bool?, autopower : Bool?){
        
        if let soundSetting = soundPen{
            guard let NeoManager = NJPenCommManager.sharedInstance() else {
                return
            }
            if(NeoManager.isPenConnected && NeoManager.hasPenRegistered){
                let pSound : CUnsignedChar = soundSetting ? 0x1 : 0x0;
                NeoManager.setPenStateAutoPower(0xFF, sound: pSound);
            }else{
                return
            }
        }else{
            if let autoP = autopower {
                guard let NeoManager = NJPenCommManager.sharedInstance() else {
                    return
                }
                if(NeoManager.isPenConnected && NeoManager.hasPenRegistered){
                    let powerSetting : CUnsignedChar = autoP ? 0x1 : 0x0;
                    NeoManager.setPenStateAutoPower(powerSetting, sound: 0xFF);
                }else{
                    return
                }
            }
            
        }
    }
    
    
    func getPressure(pressure Pressure: Int) -> String {
        switch Pressure
        {
        case 1:
            return "Level 1"
            break
        case 2:
            return "Level 2"
            break
        case 3:
            return "Level 3"
            break
        case 4:
            return "Level 4"
            break
        case 5:
            return "Level 5 (The most sensitive)"
            break
        default:
            return "default"
            break;
        }
       
    }
    
    func setPenPressure(_ pres : Int) {
        
        guard let NeoManager = NJPenCommManager.sharedInstance() else {
            return
        }
        if(NeoManager.isPenConnected && NeoManager.hasPenRegistered){
            let penpressuer : UInt16 = UInt16(pres)
            NeoManager.setPenStateWithPenPressure(penpressuer)
        }else{
            return
        }
        
    }
    
    func setNeoPenActive(_active : Bool){
        if(!_active){
            switchPenAutoPower.isEnabled = false;
            switchPenSound.isEnabled = false;
            penAutoPowerLb.textColor = UIColor.lightGray;
            penSoundLb.textColor = UIColor.lightGray;
            penSensorpressuretuningLb.textColor = UIColor.lightGray;
            inputPenPressureTf.textColor = UIColor.lightGray;
            inputPenPressureTf.isEnabled = false;
        }else{
            if(!areConnected(pen: true)){
                switchPenAutoPower.isEnabled = false;
                switchPenSound.isEnabled = false;
                penAutoPowerLb.textColor = UIColor.lightGray;
                penSoundLb.textColor = UIColor.lightGray;
                penSensorpressuretuningLb.textColor = UIColor.lightGray;
                inputPenPressureTf.textColor = UIColor.lightGray;
                inputPenPressureTf.isEnabled = false;
            }else{
                switchPenAutoPower.isEnabled = true;
                switchPenSound.isEnabled = true;
                penAutoPowerLb.textColor = UIColor.black;
                penSoundLb.textColor = UIColor.black;
                penSensorpressuretuningLb.textColor = UIColor.black;
                inputPenPressureTf.textColor = UIColor.black;
                switchPenSound.isOn = UserDefaults.standard.bool(forKey: "penSound")
                switchPenAutoPower.isOn = UserDefaults.standard.bool(forKey: "penAutoPower")
                inputPenPressureTf.isEnabled = true;
            }
        }
    }
    
    
    func areConnected(pen: Bool?)->Bool{
        if let aboutPen = pen {
            if(aboutPen){
                if let NeoManager = NJPenCommManager.sharedInstance() {
                    return (NeoManager.isPenConnected);
                }
            }else{
                if let board = MyManager.shared() {
                    return board.isConnected
                }
            }
        }else{
            if let NeoManager = NJPenCommManager.sharedInstance() {
                return (MyManager.shared().isConnected || NeoManager.isPenConnected);
            }else{
                if let board = MyManager.shared() {
                    return board.isConnected
                }
            }
        }
        return false;
    }

    
    @objc
    func penSensorPressureClicked(){
        print("**************** penSensorPressureClicked")
    }
    
   
    
    
    //MARK: - NEO Notifications
    @objc
    func receiveNeoNotification(_ notification: NSNotification){
        if let connected = notification.userInfo?["connected"] as? Bool {
            if(connected){
                setNeoPenActive(_active: connected);
            }else{
                setNeoPenActive(_active: connected);
            }
        }
    }
    
    
  
    //MARK: - other settings
    func getZoneString(index Index:Int) -> String
    {
        
        
      if Index == 1
      {
        return "1 time"
        }
        else
      {
        return "\(Index) times"
        }
    }
    
    func getSaveString(index Index:Int) -> String
    {
        
        if Index == 1
        {
            return "1 second"
        }
        else
        {
            return "\(Index) seconds"
        }
    }
    

    func selectedRow(inComponent component: Int) -> Int
    {
        return 2
        
    }
    
    @objc private func dismissView() {
        
  
        textRotate.resignFirstResponder()
        textZoneVibrate.resignFirstResponder()
        
        textAutoSave.resignFirstResponder()
        
        
    } // dismissView
    
    
    
    //MARK:- overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissViewTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        if let tap = dismissViewTap {
            
            view.addGestureRecognizer(tap)
            
        } // if let
        
        if FirebaseApp.app() == nil
        {
            FirebaseApp.configure()
        }

        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(SettingTableViewController.dismissPicker))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "selected"), style: UIBarButtonItem.Style.plain ,target: self, action: #selector(selectAction(_:)))
        let editItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = editItem
        
        imagePicker.delegate = self
        
        rotatesensorboard.delegate = self
        rotatesensorboard.dataSource = self
        penSensorPressurePv.delegate = self
        penSensorPressurePv.dataSource = self
   
        penSensorPressurePv.tag = 12
        
        
        deviceSelectionPV.delegate = self
        deviceSelectionPV.dataSource = self
        deviceSelectionPV.tag = 14
        
        versionLabel.text = "\(Bundle.main.appName) v \(Bundle.main.versionNumber) (Build \(Bundle.main.buildNumber))"
        
        switchInvertColors.isOn = UserDefaults.standard.bool(forKey: "InvertColors")
        switchDisableVibrations.isOn = UserDefaults.standard.bool(forKey: "DisableVibrations")
        switchAutoSaveOnHome.isOn = UserDefaults.standard.bool(forKey: "AutoSaveOnHome")
        switchButtonLock.isOn = UserDefaults.standard.bool(forKey: "ButtonLock")
        switchButtonOverlays.isOn = UserDefaults.standard.bool(forKey: "HideButtonOverlays")
        switchDrawingAlwaysVisible.isOn = UserDefaults.standard.bool(forKey:"DrawingAlwaysVisible")
        switchEnableAutoSave.isOn = UserDefaults.standard.bool(forKey:"AutoSave")
        switchIncognitoMode.isOn = UserDefaults.standard.bool(forKey:"IncognitoMode")
        switchShowTemplate.isOn = UserDefaults.standard.bool(forKey:"ShowTemplate")
        switchHideConnectionStatusDot.isOn = UserDefaults.standard.bool(forKey: "ConnectionStatus")
        lineWidth.setValue(UserDefaults.standard.float(forKey:"lineWidth"), animated: true)
    
        //                    UserDefaults.standard.set(neopen, forKey: "neoPen")

       
        
        lineWidthLabel.text = "Line Width: \(lineWidth.value)"
        
        
        
        if (  UserDefaults.standard.bool(forKey: "Watchmode") )
        {
            
            watchModeButton.setTitle("Watch Mode Enabled", for: UIButton.State.normal)
            watchDotCell.isHidden = false
            watchModeButton.isEnabled = false
        }
        else{
            watchModeButton.setTitle("Watch Mode", for: UIButton.State.normal)
            watchDotCell.isHidden = true
            watchModeButton.isEnabled = true
        }
        
        loggedInAs.text = "Logged in as: \(username)"
        
        rotatesensorboard.tag = 1
        textRotate.tintColor  = UIColor.clear
        textRotate.inputView = rotatesensorboard
        inputPenPressureTf.tintColor = UIColor.clear
        inputPenPressureTf.inputView = penSensorPressurePv
        inputPenPressureTf.inputAccessoryView = toolBar
        let penPressurefromDefaultuser : Int = UserDefaults.standard.integer(forKey: "penPressure")
        let penPressureLableText : ()-> String = {if(penPressurefromDefaultuser == 5){return "Level 5"}else{return self.getPressure(pressure: penPressurefromDefaultuser)}}
        inputPenPressureTf.text = penPressureLableText()

        inputDeviceSelectionTf.tintColor = UIColor.clear
        inputDeviceSelectionTf.inputView = deviceSelectionPV
        inputDeviceSelectionTf.inputAccessoryView = toolBar
        inputDeviceSelectionTf.text = devicenames[UserDefaults.standard.integer(forKey: "selectedDevice")]
        
        textRotate.inputAccessoryView = toolBar
        
        textRotate.text = getDegrees(degree: UserDefaults.standard.integer(forKey: "rotate") )
        
        zonevibrates.delegate = self
        zonevibrates.dataSource = self
      
        zonevibrates.tag = 2
        
       
      
       textZoneVibrate.tintColor = UIColor.clear
        textZoneVibrate.inputView = zonevibrates
        textZoneVibrate.inputAccessoryView = toolBar
        
        textZoneVibrate.text = getZoneString(index: UserDefaults.standard.integer(forKey: "zonevibrates") )

        
        incognitoThumbNail.bringSubviewToFront(self.view)
        let fileURL = UserDefaults.standard.url(forKey: "incognitoImage")
        if(fileURL != nil)
        {
            do {
                let imageData = try Data(contentsOf: fileURL!)
                incognitoThumbNail.image = UIImage(data: imageData)
            //    buttonSelectImage.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                incognitoThumbNail.isHidden = false
            } catch {
        
            }
        }
        else
        {
        //    buttonSelectImage.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
           // incognitoThumbNail.isHidden = true
        }
        
        autoSaveTimer.delegate = self
        autoSaveTimer.dataSource = self
     
         autoSaveTimer.tag = 3
        
                textAutoSave.tintColor = UIColor.clear
        textAutoSave.inputView = autoSaveTimer
        textAutoSave.inputAccessoryView = toolBar
           textAutoSave.text = getSaveString(index: UserDefaults.standard.integer(forKey: "autoSaveTimer") )
        
        
      setNeoPenActive(_active: UserDefaults.standard.bool(forKey: "neoPen"))
        
        
//        Neo.shared().delegate = self;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        zonevibrates.selectRow( UserDefaults.standard.integer(forKey: "zonevibrates") - 1,inComponent:  0, animated: true)
        rotatesensorboard.selectRow( UserDefaults.standard.integer(forKey: "rotate") - 1,inComponent:  0, animated: true)
        autoSaveTimer.selectRow( UserDefaults.standard.integer(forKey: "autoSaveTimer") - 1,inComponent:  0, animated: true)
        penSensorPressurePv.selectRow(UserDefaults.standard.integer(forKey: "penPressure") - 1, inComponent: 0, animated: true)
        
        if(UserDefaults.standard.integer(forKey: "selectedDevice") != 2){
            setNeoPenActive(_active: false)
        }
//        devicePV.selectRow(UserDefaults.standard.integer(forKey: "selectedDevice"), inComponent: 0, animated: false)
        deviceSelectionPV.selectRow(UserDefaults.standard.integer(forKey: "selectedDevice"), inComponent: 0, animated: false)

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNeoNotification(_:)), name: NSNotification.Name(rawValue: keyNeoNOtification), object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self);
    }
   
   
    // MARK: - Table view data source

    
    func monthdoneaction()
    {
        
    }
    
    @objc func selectAction(_ sender:UIBarButtonItem) -> Void {
       self.dismiss(animated: true, completion: nil)
    }
    
    
    //view(forRow row: Int, forComponent component: Int) -> UIView?
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let count = row+1
        if pickerView.tag == 1
        {
            switch count
            {
            case 1:
                return NSAttributedString(string: "0°", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                break;
            case 2:
                return NSAttributedString(string: "90°", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                break;
            case 3:
                return NSAttributedString(string: "-90°", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                break;
            case 4:
                return NSAttributedString(string: "180°", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
                break;
            default:
                break;
            }
        }
        else if pickerView.tag == 2
        {
            if(count == 1)
            {
                return NSAttributedString(string: "1 time", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
            else{
                
                return NSAttributedString(string: "\(count) times", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
        }
        else if pickerView.tag  == 3
        {
            if(count == 1)
            {
                return NSAttributedString(string: "1 second", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
            else{
                
                return NSAttributedString(string: "\(count) seconds", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
        }
        else if(pickerView.tag == 11){
            if(row == 0){
                return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }else
            if(row == 2 && !UserDefaults.standard.bool(forKey: "neoPen")){
                return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }else if(row == 1 && !UserDefaults.standard.bool(forKey: "isknSlate")){
                return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }else{
                return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
        }else if pickerView.tag == 12
        {
            return NSAttributedString(string: getPressure(pressure: count), attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        }else if pickerView.tag == 14 {
            if(row == 0){
                return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }else
                if(row == 2 && !UserDefaults.standard.bool(forKey: "neoPen")){
                    return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                }else if(row == 1 && !UserDefaults.standard.bool(forKey: "isknSlate")){
                    return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }else{
                    return NSAttributedString(string: devicenames[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            }
        }
        return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

    }
    
    
    
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
        
        let count = row+1
        if pickerView.tag == 1
        {
        switch count
        {
        case 1:
            return "0°"
            break;
        case 2:
            return "90°"
            break;
        case 3:
            return "-90°"
            break;
        case 4:
            return "180°"
            break;
        default:
            break;
        }
        }
        else if pickerView.tag == 2
        {
            if(count == 1)
            {
               return "1 time"
            }
            else{
                
            
            return "\(count) times"
            }
        }
        else if pickerView.tag  == 3
        {
            if(count == 1)
            {
                return "1 second"
            }
            else{
                
                
                return "\(count) seconds"
            }
        }
        else if pickerView.tag == 11
        {
            return devicenames[row];
        }
        return "b_error"
    }
    */
    
    
    @IBOutlet weak var watchModeButton: UIButton!
    
    @IBAction func watchModeButtonClick(_ sender: Any) {
        print("watchmode clicked")
        performSegue(withIdentifier: "watchpage", sender: nil)
    }
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        
    
        let fixed = roundf(sender.value / 1.0) * 1.0;
        sender.setValue(fixed, animated: true)
        
        UserDefaults.standard.set(sender.value, forKey: "lineWidth")
        lineWidthLabel.text = "Line Width: \(sender.value)"
        
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
     
        performSegue(withIdentifier: "settingstomain", sender: nil)
    }
    


    @IBAction func switchPenAP(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "penAutoPower")
        UserDefaults.standard.synchronize()
        applyPenSettings(nil, autopower: sender.isOn)
    }
    
    @IBAction func switchPensound(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "penSound")
        UserDefaults.standard.synchronize()
        applyPenSettings(sender.isOn, autopower: nil)
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem)
    {
                self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
   
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
        
    }
    
    
    
    
    
    
  
    @IBAction func invertColors(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "InvertColors")
    }
    @IBOutlet weak var loggedInAs: UILabel!
    
    @IBAction func disableVibrations(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "DisableVibrations")
    }
    @IBOutlet weak var watchDotCell: UITableViewCell!
    
    @IBAction func autoSaveOnHome(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "AutoSaveOnHome")
    }
    
    @IBAction func buttonLock(_ sender: UISwitch) {
        UserDefaults.standard.set(false, forKey: "DrawingAlwaysVisible")
        drawingAlwaysVisibleCell.isOn = false
        UserDefaults.standard.set(sender.isOn, forKey: "ButtonLock")
    }
    
    @IBAction func deactivateDevice(_ sender: Any) {
        if !Reachability.isConnectedToNetwork(){
            let dialogMessage = UIAlertController(title: "Error", message: "No Internet Connection - You cannot deactivate this device while offline.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                return
                
                
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
            
        }
        
        
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        
         let db = Firestore.firestore()
        let docRef = db.collection("users").document(username)
        
        if(MyManager.shared()!.isConnected)
        {
        MyManager.shared()?.discClicked = true
        MyManager.shared()?.disc()
        }
        
    
            docRef.updateData([
                "isActivated": false
            ]) { err in
                if let err = err {
              
                } else {
               
                }}
        

        
        performSegue(withIdentifier: "toWalkthrough", sender: nil)
    }
    
    @IBAction func hideButtonOverlays(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "HideButtonOverlays")
    }
    
    
    @IBAction func drawingAlwaysVisile(_ sender: UISwitch) {
        switchIncognitoMode.isOn = false
        switchButtonLock.isOn = false
            UserDefaults.standard.set(false, forKey: "ButtonLock")
        
        UserDefaults.standard.set(false, forKey: "IncognitoMode")
        UserDefaults.standard.set(sender.isOn, forKey: "DrawingAlwaysVisible")
    }
    
    @IBAction func autoSave(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "AutoSave")
    }
    
    @IBAction func incognitoMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "IncognitoMode")
          UserDefaults.standard.set(false, forKey: "DrawingAlwaysVisible")
        drawingAlwaysVisibleCell.isOn = false
        
      //  incognitoThumbNail.isHidden = !sender.isOn
        let fileURL = UserDefaults.standard.url(forKey: "incognitoImage")
        if(fileURL == nil)
        {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
          DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func reportAProblem(_ sender: UIButton) {

        let subject = ""
        let body = "What did you expect to happen:\nHow can we reproduce this error:\nYour phone/tablet model:\nYour phone/tablet OS version: \nYour ThoughtCast version:\nAny other info you think might help us solve your problem:"
        
        
        
        let coded = "mailto:support@thoughtcastapp.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL: NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.openURL(emailURL as URL)
            }
        }
    /*
        print("attempt")
        let subject = ""
        let body = "What did you expect to happen:"
                    + "How can we reproduce this error:"
                    + "Your phone/tablet model:"
                    + "Your phone/tablet OS version:"
                    + "Your ThoughtCast version: "
                    + "Any other info you think might help us solve your problem:"
        
        
        
        let encodedParams = "subject=\(subject)&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))"
        let url = "mailto:support@thoughtcastapp.com?\(encodedParams)"
        
        if let emailURL = NSURL(string: url) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.openURL(emailURL as URL)
            }
            
        }
 */
        
    }
    

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func contactSupport(_ sender: UIButton) {
        let subject = ""
        let body = ""
        
        
        
        let encodedParams = "subject=\(subject)&body=\(body)"
        let url = "mailto:support@thoughtcastapp.com?\(encodedParams)"
        
        if let emailURL = NSURL(string: url) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.openURL(emailURL as URL)
            }
            
    }
    }
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    @IBAction func showTemplate(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ShowTemplate")
        
        print("\(sender.isOn) <- ShowTemplate")
    }
    
 
    
    
    @IBAction func connectionStatusDot(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ConnectionStatus")
   
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     
        return cell
    }
 */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toWalkthrough"){
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
 

}


extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
