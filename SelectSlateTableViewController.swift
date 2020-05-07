//
//  SelectSlateTableViewController.swift
//  
//
//  Created by David Kachlon on 12/6/18.
//

import UIKit



class SelectSlateTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var currentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchiSketchnoteController(self)
        
        currentTableView.delegate = self
        currentTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Devices List"
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "cell"
        
        
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! UITableViewCell
        
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default , reuseIdentifier: cellIdentifier)
            
        }
        
       
        cell.textLabel!.text = MyManager.shared().strSlatesList.object(at: indexPath.row) as! String
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}



