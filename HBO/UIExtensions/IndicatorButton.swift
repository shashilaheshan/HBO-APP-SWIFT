//
//  IndicatorButton.swift
//  HBO
//
//  Created by Shashila Heshan on 17/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    func loadingIndicator(show: Bool) {
        let tag = 9876
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x:buttonWidth/2, y:buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }}
