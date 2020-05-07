//
//  CircleButton.swift
//  BoringSSL
//
//  Created by David Kachlon on 12/19/18.
//

import UIKit

@IBDesignable class CircleButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
//        refreshCorners(value: cornerRadius)

        
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
      
    }
    
    

        


}



