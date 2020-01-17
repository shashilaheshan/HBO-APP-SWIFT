//
//  DashboardViewController.swift
//  HBO
//
//  Created by Shashila Heshan on 16/1/20.
//  Copyright © 2020 Shashila Heshan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet weak var txtMovieName: UITextField!
    
    @IBOutlet weak var txtDirector: UITextField!
    
    @IBOutlet weak var txtRating: UITextField!
    
    @IBOutlet weak var btnAddData: btnCustom!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addCustomStylesToView()
       
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "StarterViewController") as! StarterViewController
            
            let navController = UINavigationController(rootViewController: VC1)
            
        
            self.present(navController, animated:true, completion: nil)
            
        } catch let err {
            
             let alert = AlertDialog()
            
             alert.showAlert(title: "Error occured", message: "Error while loggin out: \(err)",buttonText: "Try adding agian")
        
        }
        
    }

    @IBAction func storeData(_ sender: Any) {
        
        let validator = ValidateFields()
        
        let alert = AlertDialog()
        
        if(validator.validateMovieForm(name: txtMovieName.text!, director: txtDirector.text!, rating: txtRating.text!)) {
            
            self.btnAddData.loadingIndicator(show: true)
            
        
            
            var db: Firestore!
            
            db = Firestore.firestore()
            
            db.collection("movies").addDocument(data: [
                "name": txtMovieName.text!,
                "director":txtDirector.text!,
                "rating": txtRating.text! ,
                "image":"https://i.ytimg.com/vi/Z1i8kbjsvHw/maxresdefault.jpg"
                ])
            { err in
                if let err = err {
                    
                    alert.showAlert(title: "Error occured", message: "Error adding document: \(err)",buttonText: "Try adding agian")
                    
                } else {
                    
                    self.clearFields()
                    
                    self.btnAddData.loadingIndicator(show: false)
                }
            }
            
        } else {
            
                alert.showAlert(title: "Error occured", message: "One or more fields values are invalid"
                ,buttonText: "Try adding agian")
            
        }
        
        
    }
    
    func addCustomStylesToView() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        txtMovieName.setLeftPaddingPoints(8)
        
        txtDirector.setLeftPaddingPoints(8)
        
        txtRating.setLeftPaddingPoints(8)
        
        txtMovieName.placeholderColor(color: UIColor.white)
        
        txtDirector.placeholderColor(color: UIColor.white)
        
        txtRating.placeholderColor(color: UIColor.white)
    }
    
    func clearFields()  {
        txtMovieName.text = ""
        
        txtDirector.text = ""
        
        txtRating.text = ""
    }

}
