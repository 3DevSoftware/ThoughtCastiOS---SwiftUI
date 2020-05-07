//
//  Permissions.swift
//  ThoughtCast
//
//  Created by David Kachlon on 3/26/19.
//  Copyright © 2019 ThoughtCast. All rights reserved.
//

import UIKit
import Photos
class Permissions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPhotoLibraryPermission()
        // Do any additional setup after loading the view.
    }
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "notifications") as! Notifications                
                
//                self.dismiss(animated: false, completion: {
//                    self.present(vc, animated: true, completion: nil)
//                })
                self.present(vc, animated: true, completion: nil)

            }
            print("authorized")
            break
        //handle authorized status
        case .denied, .restricted :
            //handle denied status
            break
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                // as above
                case .denied, .restricted:
                    break
                // as above
                case .notDetermined:
                    break
                // won't happen but still
                default:
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "notifications") as! Notifications
                        self.present(vc, animated: true, completion: nil)
       
//                        self.dismiss(animated: false, completion: {
//                             self.present(vc, animated: true, completion: nil)
//                        })
                        
                    }
                   
                }
            }
            break
        }
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
