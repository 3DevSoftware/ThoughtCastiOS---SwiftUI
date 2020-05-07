//
//  SelectSlateTableTableViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/6/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit

import CoreBluetooth
import CustomNavigationBar

class CustomButton: UIButton{
    override func draw(_ rect: CGRect) {
        let width = 15.0
        let height = Float(rect.size.height)
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        context?.move(to: CGPoint(x: CGFloat(width * 5.0 / 6.0), y: CGFloat(height * 0.0 / 10.0)))
        context?.addLine(to: CGPoint(x: CGFloat(width * 0.0 / 6.0), y: CGFloat(height * 5.0 / 10.0)))
        context?.addLine(to: CGPoint(x: CGFloat(width * 5.0 / 6.0), y: CGFloat(height * 10.0 / 10.0)))
        context?.addLine(to: CGPoint(x: CGFloat(width * 6.0 / 6.0), y: CGFloat(height * 9.0 / 10.0)))
        context?.addLine(to: CGPoint(x: CGFloat(width * 2.0 / 6.0), y: CGFloat(height * 5.0 / 10.0)))
        context?.addLine(to: CGPoint(x: CGFloat(width * 6.0 / 6.0), y: CGFloat(height * 1.0 / 10.0)))
        context?.closePath()
        
        context?.setFillColor(UIView().tintColor!.cgColor)
        context?.fillPath()
    }

    
}


@objc
class SelectSlateTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    
    @IBOutlet weak var other_constraint: NSLayoutConstraint!
    @IBOutlet weak var sensorBoardList: UILabel!
    
    @IBOutlet weak var iPhone_X_Constraint: NSLayoutConstraint!
    var cbCentralManager: CBCentralManager!
    
    @IBOutlet weak var tableview: UITableView!
    
    
var navBar: UINavigationBar = UINavigationBar()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var viewTest: UIView!

    @IBOutlet weak var disableTwo: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var disableThis: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var outletTableView: UITableView!
    var bottomlabel = UILabel()
    /*
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        header.textLabel?.textColor = UIColor.black
        
    }
 */

 
    var neo:Neo!
    
    @objc func buttonClicked(sender:UIButton)
    {
        if(sender.tag == 1){
            
            //Do something for tag 1
        }
        print("buttonClicked")
    }

    override func viewWillAppear(_ animated: Bool) {
    
       self.tableview.reloadData()


    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    @objc
    func addTapped()
    {
    }
    

    
  


    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch(UserDefaults.standard.integer(forKey: "selectedDevice")){
        case 2:
            self.title = "Select Scribe Pen"
            break
        default:
            self.title = "Select Sensor Board"
            break
        }
        
        
        self.tableview.reloadData()
        automaticallyAdjustsScrollViewInsets = false

        self.prepareList()

        /*
        bottomlabel = UILabel(frame: CGRect(x: 5, y: 30, width: self.view.frame.width, height: 40))
        bottomlabel.text = "Select Sensor Board"
        navigationController?.navigationBar.addSubview(bottomlabel)
bottomlabel.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        
       navigationController?.navigationBar.height = 400.0
 */
        

        
        
        

       /*
        if UIApplication.shared.statusBarOrientation.isLandscape {
            if(!self.hasTopNotch)
            {
                self.disableThis.isActive = false
                self.other_constraint.isActive = false
                self.iPhone_X_Constraint.isActive = true
                self.disableTwo.isActive = false
                print("has top notch")
            }
            else
            {
                self.iPhone_X_Constraint.isActive = false
                self.other_constraint.isActive = true
                self.disableTwo.isActive = true
                self.disableThis.isActive = true
            }
        } else {
            self.iPhone_X_Constraint.isActive = false
            self.disableTwo.isActive = true
            self.other_constraint.isActive = true
            
            self.disableThis.isActive = true
            // activate portrait changes
        }
    */
     
     /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.title = "TEST"
      */
        
        
    
      
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //create a button or any UIView and add to subview
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
    }

    // MARK: - Table view data source

    
    override func viewWillLayoutSubviews() {
      
      
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
            statusBar?.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        }
    
     
    }
    
    

    
    func prepareList()  {
        cbCentralManager   = CBCentralManager()
        cbCentralManager.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        //MyManager.shared().currentPage = SELECT_SLATE
        MyManager.shared().initx()
        
        
        if UserDefaults.standard.integer(forKey: "selectedDevice") == 2
        {
            neo = Neo.shared()
            neo.getReady()
        }else{
            launchiSketchnoteController(self)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC: ViewController = storyboard.instantiateViewController(withIdentifier: "mainpage") as! ViewController
        //         viewC.HoldBack = redrawfarPoints
        let transition = CATransition()
        transition.duration = 0.3
        
        
        
        transition.type = CATransitionType.reveal
        
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewC, animated: false, completion: nil)
    }
    
    
    @objc func backClicked() {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC: ViewController = storyboard.instantiateViewController(withIdentifier: "mainpage") as! ViewController
        //         viewC.HoldBack = redrawfarPoints
        let transition = CATransition()
        transition.duration = 0.3
        
        
        
        transition.type = CATransitionType.reveal
        
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewC, animated: false, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("ONE SECTION.")
        return 1
    }
    

    
    
    override func viewDidLayoutSubviews() {
        
        
        

        /*
        if UIApplication.shared.statusBarOrientation.isLandscape {
            if(!self.hasTopNotch)
            {
                self.disableThis.isActive = false
                self.other_constraint.isActive = false
                self.iPhone_X_Constraint.isActive = true
                self.disableTwo.isActive = false
                print("has top notch")
            }
            else
            {
                self.iPhone_X_Constraint.isActive = false
                self.other_constraint.isActive = true
                self.disableTwo.isActive = true
                self.disableThis.isActive = true
            }
        } else {
            self.iPhone_X_Constraint.isActive = false
            self.disableTwo.isActive = true
            other_constraint.isActive = true
            
            self.disableThis.isActive = true
            // activate portrait changes
        }
 */
    }
    

 
 
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
        
            /*
            if UIApplication.shared.statusBarOrientation.isLandscape {
                if(!self.hasTopNotch)
                {
                    self.disableThis.isActive = false
                    self.other_constraint.isActive = false
                    self.iPhone_X_Constraint.isActive = true
                    self.disableTwo.isActive = false
                    print("has top notch")
                }
                else
                {
                    self.iPhone_X_Constraint.isActive = false
                    self.other_constraint.isActive = true
                    self.disableTwo.isActive = true
                    self.disableThis.isActive = true
                }
            } else {
                self.iPhone_X_Constraint.isActive = false
                self.disableTwo.isActive = true
                self.other_constraint.isActive = true
                
                self.disableThis.isActive = true
                // activate portrait changes
            }
 
        })*/
    })
    }
    
    @objc func doReload()
    {
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
       
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("trying to connect to \(MyManager.shared().strSlatesList.object(at: indexPath.row) as! String)")
    

        if(cbCentralManager.state == .poweredOn && cbCentralManager != nil)
        {
            print("WORKED")
            if(MyManager.shared().strSlatesList.object(at: indexPath.row) as! String == SCRIBE_NAME){
                if neo == nil{
                    neo = Neo();
                }
                neo.startPen()
                self.navigationController?.popViewController(animated: false)
            }else{
                connectToPeripheralByName(MyManager.shared().strSlatesList.object(at: indexPath.row) as! String);
            }
        }
    else
        {
            let dialogMessage = UIAlertController(title: "Error", message: "You need bluetooth enabled to connect to a sensor board.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         self.dismiss(animated: false, completion: nil)
                
            })
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
         
            
    }
    }

    @objc func selectAction(_ sender:UIBarButtonItem) -> Void {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC: ViewController = storyboard.instantiateViewController(withIdentifier: "mainpage") as! ViewController
        //         viewC.HoldBack = redrawfarPoints
        let transition = CATransition()
        transition.duration = 0.3
        
        
       
        transition.type = CATransitionType.push
    
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewC, animated: false, completion: nil)
        

    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    

 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        // #warning Incomplete implementation, return the number of rows
    print("TESTING: \(MyManager.shared().strSlatesList.count)")
        return MyManager.shared().strSlatesList.count
        
    }
    

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = "\(MyManager.shared().strSlatesList.object(at: indexPath.row))"
        cell.textLabel?.font = UIFont(name: "SFProText-Regular", size: 19
            ) as! UIFont
        
        return cell
    }
    
//


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

   
}


extension UIApplication {
    


    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
        
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}





class MyNavigationBar: UINavigationBar {
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
}


