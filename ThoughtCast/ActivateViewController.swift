//
//  ActivateViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/2/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import Firebase
import Photos
class ActivateViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        
    }
    
    @IBAction func activate(_ sender: Any) {
        let db = Firestore.firestore()
        var strusername: String = username.text!
        var strpassword: String = password.text!
        let defaults = UserDefaults.standard

        print("-> just a test -> \(UserDefaults.standard.string( forKey: "loginID") as! String)")
        if(strusername.isEmpty)
        {
          
            let dialogMessage = UIAlertController(title: "Error", message: "Please enter a username and a password.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                
                
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            return
        }
        
        
        if(strpassword.isEmpty)
        {
            let dialogMessage = UIAlertController(title: "Error", message: "Please enter a username and a password.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                
                
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            return
        }
        
        
        if !Reachability.isConnectedToNetwork(){
            let dialogMessage = UIAlertController(title: "Error", message: "Please connect to internet to activate.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                return
                
                
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)

        }
        
        let docRef = db.collection("users").document(strusername)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let password = document.get("password") as! String
                let isEqual = (password == strpassword)
                let activated = document.get("isActivated") as! Bool
                let watchMode = document.get("watchmode") as! Bool
                let currentHash = document.get("loginID")
                print("\(watchMode) <- test")
                if(isEqual)
                {
                    if(!activated)

                    {
                       
                        
                    
                        print("hmm.. .should be working here.")
                        
                        
        
                        
                            docRef.updateData([
                                "isActivated": true,
                                "deviceOS":"iOS",
                                "loginID": UserDefaults.standard.string( forKey: "loginID") as! String
                            ]) { err in
                                if let err = err {
                                    
                                } else {
                                    
                                }
                            }
                            UserDefaults.standard.set(true, forKey: "LoggedIn")
                            print("logged in completely")
                            UserDefaults.standard.set(strpassword, forKey: "Password")
                            if(watchMode)
                            {
                                
                                UserDefaults.standard.set(true, forKey: "Watchmode")
                                
                            }
                            else
                            {
                                UserDefaults.standard.set(false, forKey: "Watchmode")
                            }
                            UserDefaults.standard.set(strusername, forKey: "loggedInAs")
                            UserDefaults.standard.set(strpassword, forKey: "loggedInPassword")
                            
                        
            
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "photos") as! Permissions
                        self.present(vc, animated: true, completion: nil)

                        if let pageParent = self.parent as? PageViewController
                        {
                            let emptyvc = UIViewController.init()
                            pageParent.delegate = nil;
                            pageParent.dataSource = nil;
                            pageParent.setViewControllers([emptyvc], direction: .forward, animated: false, completion: nil);
                        }
                        
                        }
                    else{
                        UserDefaults.standard.set(false, forKey: "LoggedIn")
                        
                        let dialogMessage = UIAlertController(title: "Error", message: "Another device is already activated. Please visit thoughtcastapp.com/owners to reset activation.", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            
                            
                            
                        })
                         dialogMessage.addAction(ok)

                       
                        self.present(dialogMessage, animated: true, completion: nil)

                        
                    }
                        
        
                        
                        
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "LoggedIn")
                        
                        
                        let dialogMessage = UIAlertController(title: "Error", message: "Your username or password is invalid.", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            
                            
                            
                        })
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                        
                        
                        
              
                    }
                }
                else
                {
                    UserDefaults.standard.set(false, forKey: "LoggedIn")
                    let dialogMessage = UIAlertController(title: "Error", message: "Your username or password is invalid.", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
                        
                        
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                }
                
            }
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
