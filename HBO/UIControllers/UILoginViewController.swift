//
//  UILoginViewController.swift
//  HBO
//
//  Created by Shashila Heshan on 6/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import UIKit

class UILoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSylesToLogin()
    }
    func addSylesToLogin() {
        txtEmail.roundCorners([.topLeft,.topRight], radius: 10)
        txtPass.roundCorners([.bottomLeft,.bottomRight], radius: 10)
        txtEmail.setLeftPaddingPoints(8)
        txtPass.setLeftPaddingPoints(8)
        txtEmail.placeholderColor(color: UIColor.white)
        txtPass.placeholderColor(color: UIColor.white)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
       let validator = ValidateFields()
        if(validator.usernameValid(username: (txtEmail.text ?? "")) && validator.passwordValid(password: txtPass.text ?? "")){
            let alert = AlertDialog();
            
            alert.showAlert(title: "Logged In", message: "You have been successfully logged in", buttonText: "Dashboard")
            
        }else{
            let alert = AlertDialog();
            
            alert.showAlert(title: "Error", message: "Username or password is invalid", buttonText: "Register")
        }
        
    
    
}
}
