//
//  ZoneTemplateViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/18/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import SwipeCellKit

class ZoneTemplateViewController: UITableViewController, SwipeTableViewCellDelegate {


    
    var ImageToPass: UIImage!
    var indexRow: Int!
    var fileURLs: [URL]!
    var redrawfarPoints: [(point: CGPoint, type: CGPathElementType)] = []
    var pathToPass: UIBezierPath!
    var justRemoved = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            
            
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil).filter{ $0.pathExtension == "saved" }
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        

        self.title = "Load Zone Template"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ZoneTemplateViewController.cancel))
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "eventCell")
     
         // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("is the error here")
        
        if(justRemoved)
        {
            justRemoved = false
            return fileURLs.count - 1
        }
        else{
            return fileURLs.count}
    }
    
    @objc
    func cancel() {
        
   
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC: ZoneModeViewController = storyboard.instantiateViewController(withIdentifier: "ZoneMode") as! ZoneModeViewController
        

        let transition = CATransition()
        transition.duration = 0.2
        
        
        viewC.redrawfarPoints = redrawfarPoints
         transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
       
        if(ImageToPass != nil)
        {
            viewC.imagePassed = ImageToPass
        }
        viewC.redrawfarPoints = redrawfarPoints
        viewC.passedBack = pathToPass
        self.present(viewC, animated: false, completion: nil)
        

        
       
        
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        print("did it crash here")
        
        indexRow = indexPath.row
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        let viewC: ZoneModeViewController = storyboard.instantiateViewController(withIdentifier: "ZoneMode") as! ZoneModeViewController
        
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        let transition = CATransition()
        transition.duration = 0.2
        

        viewC.redrawfarPoints = redrawfarPoints
        print("\(currentCell.textLabel?.text)).saved")
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        viewC.imageX = loadImageFromDiskWith(fileName: "\(currentCell.textLabel?.text as! String).saved"  as! String )
        viewC.imagetoLoad = true
        viewC.redrawfarPoints = redrawfarPoints
        viewC.passedBack = pathToPass
         self.present(viewC, animated: false, completion: nil)
        

        
        
    }
    
    

    
func loadImageFromDiskWith(fileName: String) -> UIImage? {

  let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: imageUrl.path)
        
        return image

    }

    return nil
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            if (segue.identifier == "toZoneSetupPage") {
                let destination = segue.destination as! ZoneModeViewController
             
                destination.passedIndex = indexRow
                destination.imagetoLoad = true
                destination.redrawfarPoints = redrawfarPoints
                destination.fingerPaintView.first = false
                
        }
                
                
            
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
    
          options.expansionStyle = .selection

        options.transitionStyle = .reveal
        
        
        return options
    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let fileManager = FileManager.default
        
        var testPath = indexPath.row
        
 
           let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
     let closure: (UIAlertAction) -> Void = { _ in
        self.fileURLs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic) }
 
            //self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
     /*

 
 */
            
            // Check if file exists
      

            
            
        let more = SwipeAction(style: .destructive, title: nil) { action, indexPath in
    
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this template?", preferredStyle: .alert)
            
           
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive , handler: { action in
                do {
                    try fileManager.removeItem(atPath: self.fileURLs[testPath].path)
                }
                catch {
                    
                }
                
                self.fileURLs.remove(at: testPath)
                
                self.tableView.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
        let RENAME =
             SwipeAction(style: .default , title: "Rename") { action, indexPath in
                 print("\(self.fileURLs[testPath])")
                
                
                
                let ac = UIAlertController(title: "Rename", message: "Enter the new name of the file you'd like to save this zone setup as.", preferredStyle: .alert)
                ac.addTextField()
                
                let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
                    let answer = ac.textFields![0]
                    
               
                    print("renaming")
                    
             
                    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
                    
                    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
                    
                    
                    if let dirPath = paths.first {
                        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent("\(answer.text as! String).saved")
                        print("test: from  \(self.fileURLs[testPath].path) <- to ->\(imageUrl.path)")
                        do {
                            try fileManager.moveItem(at: self.fileURLs[testPath], to: imageUrl)
                             self.tableView.reloadData()
                        }
                        catch {}
                        
                    }
                    
                    
                
                    let fileManager = FileManager.default
                    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    do {
                        
                        
                       self.fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil).filter{ $0.pathExtension == "saved" }
                        // process files
                    } catch {
                        print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
                    }
                    
                    
                    
                    self.tableView.reloadData()
            
                 
                    
                    // do something interesting with "answer" here
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [unowned ac] _ in
                    
                }
                
            
                self.present(ac, animated: true)
                
                
                
                
               
                    print("renamed")
 
        }
        
        more.title = "Delete"
 RENAME.title = "Rename"
       
        RENAME.backgroundColor = UIColor.blue
        RENAME.transitionDelegate = ScaleTransition.default
        RENAME.hidesWhenSelected = false
        more.hidesWhenSelected = false
        
      more.transitionDelegate = ScaleTransition.default
        return [more, RENAME]
    }


    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! SwipeTableViewCell
        
       
        print("double test: \(fileURLs[indexPath.row].lastPathComponent)")
        
        
        cell.hideSwipe(animated: true)
    
        cell.swipeOffset = 0.0
        cell.showSwipe(orientation: .left)
  
       //var test = loadImageFromDiskWith(fileName: fileURLs[indexPath.row].lastPathComponent) as! UIImage
        
       // cell.imageView?.image =
   //     let data = try? Data(contentsOf: fileURLs[indexPath.row].absoluteURL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.imageView?.image = loadImageFromDiskWith(fileName: fileURLs[indexPath.row].lastPathComponent)
        
        
        cell.textLabel?.text = fileURLs[indexPath.row].lastPathComponent.characters.split(separator: ".").map(String.init).first
    //    cell.imageView?.image = UIImage(named: "greendot")
    
        
       cell.delegate = self
        return cell
    }
    

    
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

