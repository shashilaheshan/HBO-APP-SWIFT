//
//  ActivityIndicatorCustom.swift
//  HBO
//
//  Created by Shashila Heshan on 17/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import Foundation
import UIKit
extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(style: activityIndicatorStyle)
        center = parentView.center
        self.color = UIColor.white
        parentView.addSubview(self)
    }
}
