//
//  PageViewController.swift
//  ThoughtCast
//
//  Created by David Kachlon on 12/2/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

import UIKit
import Firebase

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    var justDisced = false
    var test = false
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        print("ok transitioning")
    }
    
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let loggedIn = UserDefaults.standard.bool(forKey: "LoggedIn")
        print("hereee \(loggedIn)")
        MyManager.shared().currentPage = WALKTHROUGH
        
        if FirebaseApp.app() == nil
        {
            FirebaseApp.configure()
        }
        
        if(loggedIn)
        {
            
                              self.performSegue(withIdentifier: "skipMainpage", sender: nil)
                            return
                        
                        
                        
                        
                    }
                    
                    
         else
        {
    
            
 
        print("here, what?")
        
        self.dataSource = self
        self.delegate = self
        
         
            
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
    }
            if(justDisced)
            {
                let dialogMessage = UIAlertController(title: "Error", message: "Your account is no longer active for this instance of ThoughtCast.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 
                    
                    
                })
                
                
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                
            }
            
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            }else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    

    
    func newVc(viewController: String) -> UIViewController {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            storyboard = UIStoryboard(name: "Maini", bundle: nil)
        }
        return storyboard.instantiateViewController(withIdentifier: viewController)
    }
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "pageOne"),
                self.newVc(viewController: "pageTwo"),
                self.newVc(viewController: "pageThree"),
                self.newVc(viewController: "pageFour"),
                self.newVc(viewController: "activate")
        ]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
       // self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    

    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
           // return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
           // return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
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
