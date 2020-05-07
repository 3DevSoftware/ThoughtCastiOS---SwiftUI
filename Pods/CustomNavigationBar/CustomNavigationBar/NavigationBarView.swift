//
//  NavigationBarView.swift
//  CustomNavigationBar
//
//  Created by Praveenkumar Somu on 27/1/2562 BE.
//  Copyright © 2562 Praveenkumar Somu. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    var context:UIViewController?
   
    func setUpTheme(backgroundColor:UIColor? = nil,titleFont:UIFont? = nil,subtitleFont:UIFont? = nil,title:String,subTitle:String,titleTextColor:UIColor,subtitleTextColor:UIColor,titleAlignment:NSTextAlignment,subtitleAlignment:NSTextAlignment,showBackButton:Bool = true,backButtonImage:UIImage?,context:UIViewController){
        self.context = context
        /* Set Background color of custom navigationbar */
        self.backgroundColor = backgroundColor
        
        /* Create UILabel  */
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        /* Support Multiple lines set numberofLines = 0*/
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
        
        /* Set up text and alignments and text color*/
        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.textColor = titleTextColor
        titleLabel.textAlignment = titleAlignment
        subtitleLabel.text = subTitle
        subtitleLabel.font = subtitleFont
        subtitleLabel.textAlignment = subtitleAlignment
        subtitleLabel.textColor = subtitleTextColor
        
        /* Add Labels to the NavigationbarView*/
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        /* Set up Constraints using layout anchors*/
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor , constant: 60).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:leftAnchor , constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:rightAnchor , constant: -20).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        
        /*Create Back button if showBackButton is true (normally for intial screen it is false))*/
        if showBackButton {
            let backButton = UIButton(frame: CGRect(x: 0, y: 40, width: 45, height: 50))
            backButton.setImage(backButtonImage, for: .normal)
            backButton.setTitle("Back", for: .normal)
            backButton.addTarget(self, action: #selector(dismiss) , for: .touchUpInside)
            addSubview(backButton)
        }
    }
    
    @objc  func dismiss(){
        context?.dismiss()
    }

}

extension UIViewController{
    public  func addCustomNavbarView(backgroundColor:UIColor = UIColor.blue,titleFont:UIFont? = nil,subtitleFont:UIFont? = nil,title:String,subTitle:String,titleTextColor:UIColor = UIColor.white,subtitleTextColor:UIColor = UIColor.white,titleAlignment:NSTextAlignment = .center,subtitleAlignment:NSTextAlignment = .center, showBackButton:Bool = true,backButtonImage:UIImage? = nil){
        // Create NavigationbarView  and add it to stack view
            let navbarView = NavigationBarView()
            let stackView = UIStackView()
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
        //setup stack view constraints
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            stackView.addArrangedSubview(navbarView)
            stackView.addArrangedSubview(navbarView)
        // setup Navigationbar theme
            navbarView.setUpTheme(backgroundColor: backgroundColor, titleFont: titleFont, subtitleFont: subtitleFont, title: title, subTitle: subTitle, titleTextColor: titleTextColor, subtitleTextColor: subtitleTextColor, titleAlignment: titleAlignment,subtitleAlignment: subtitleAlignment, showBackButton: showBackButton, backButtonImage: backButtonImage, context: self)
        // Setup navigation bar constraints
            navbarView.translatesAutoresizingMaskIntoConstraints = false
            navbarView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
            navbarView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
            navbarView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
            navbarView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    func dismiss(){
        if presentingViewController != nil || navigationController?.presentingViewController?.presentedViewController == navigationController{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
}
