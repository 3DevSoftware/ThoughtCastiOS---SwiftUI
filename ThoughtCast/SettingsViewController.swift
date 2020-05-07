//
//  SettingsViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 1/15/19.
//  Copyright © 2019 ThoughtCast. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController,  UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    var rotatesensorboard = UIPickerView()
    var zonevibrates = UIPickerView()
    var autoSaveTimer = UIPickerView()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textAutoSave: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FirebaseApp.app() == nil
        {
            FirebaseApp.configure()
        }
        
        
        imagePicker.delegate = self
        
        rotatesensorboard.delegate = self
        rotatesensorboard.dataSource = self
        rotatesensorboard.selectRow(UserDefaults.standard.integer(forKey: "rotate") , inComponent: 0, animated: false)
        
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(SettingTableViewController.dismissPicker))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        rotatesensorboard.tag = 1
        textRotate.tintColor  = UIColor.clear
        textRotate.inputView = rotatesensorboard
        textRotate.inputAccessoryView = toolBar
        
        textRotate.text = getDegrees(degree: UserDefaults.standard.integer(forKey: "rotate") )
        
        zonevibrates.delegate = self
        zonevibrates.dataSource = self
        zonevibrates.selectRow(UserDefaults.standard.integer(forKey: "zonevibrates")  , inComponent: 0, animated: false)
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
        
        autoSaveTimer.selectRow(UserDefaults.standard.integer(forKey: "autoSaveTimer") - 1, inComponent: 0, animated: false)
        autoSaveTimer.tag = 3
        
        textAutoSave.tintColor = UIColor.clear
        textAutoSave.inputView = autoSaveTimer
        textAutoSave.inputAccessoryView = toolBar
        textAutoSave.text = getSaveString(index: UserDefaults.standard.integer(forKey: "autoSaveTimer") )
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1
        {
            UserDefaults.standard.set(row+1, forKey: "rotate")
            
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
            UserDefaults.standard.set(row+1, forKey: "autoSaveTimer")
            textAutoSave.text = "\(row+1) seconds"
            
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
        
        return 1
    }
    
    @objc func selectAction(_ sender:UIBarButtonItem) -> Void {
        performSegue(withIdentifier: "settingToMain", sender: nil)
    }
    
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
        
        return "b_error"
    }
    
    @IBOutlet weak var watchModeButton: UIButton!
    
    @IBAction func watchModeButtonClick(_ sender: Any) {
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
    
    
    
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "settingToMain", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let editItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = editItem
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(username)
        
        
        
        
        
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
    
    @IBAction func showTemplate(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ShowTemplate")
    }
    
    
    @IBAction func connectionStatusDot(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ConnectionStatusDot")
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
