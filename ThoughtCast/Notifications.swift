//
//  Notifications.swift
//  ThoughtCast
//
//  Created by David Kachlon on 3/26/19.
//  Copyright © 2019 ThoughtCast. All rights reserved.
//

import UIKit
import UserNotifications


class Notifications: UIViewController {

    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            DispatchQueue.main.async {
                /*
 let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainpage") as! ViewController
 let navigationController = UINavigationController(rootViewController: vc);
 self.present(navigationController, animated: true, completion: nil)
 */
                
                
                let delegate = UIApplication.shared.delegate as! AppDelegate


//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainnavigation")
                
//                self.dismiss(animated: false, completion: {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough")
//                    delegate.window?.rootViewController = vc
//
//                })
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthrough")
                delegate.window?.rootViewController = vc
                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
//                self.dismiss(animated: false, completion: nil);
            }
        }
        UIApplication.shared.registerForRemoteNotifications() // you can also set here for local notification.
     
    }
    
    override func viewDidLayoutSubviews() {
        
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




