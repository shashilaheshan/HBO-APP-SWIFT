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
import LocalAuthentication

class DashboardViewController: UIViewController {

    @IBOutlet weak var txtMovieName: UITextField!
    
    @IBOutlet weak var txtDirector: UITextField!
    
    @IBOutlet weak var txtRating: UITextField!
    
    @IBOutlet weak var btnAddData: btnCustom!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addCustomStylesToView()
       
    }
    
    @IBAction func btnTouchID(_ sender: Any) {
        
         let alert = AlertDialog()
       
        
        let myContext = LAContext()
        
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
//                            self.successLabel.text = "Awesome!!... User authenticated successfully"
                            
                            alert.showAlert(title: "Success", message: "Awesome!!... User authenticated successfully.",buttonText: "Okay")
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                              alert.showAlert(title: "Error", message: "Erro while Authenticating.",buttonText: "Okay")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
               alert.showAlert(title: "Error", message: "Erro while Authenticating.",buttonText: "Okay")
            }
        } else {
            // Fallback on earlier versions
            
           alert.showAlert(title: "Error", message: "Erro while Authenticating.",buttonText: "Okay")
        }
        
        
    }

    @IBAction func btnFaceID(_ sender: Any) {
        
        let alert = AlertDialog()
        
        let localAuthenticationContext = LAContext()
        
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
        
        var authorizationError: NSError?
        
        let reason = "Authentication is required for you to continue"
        
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            
            _ = localAuthenticationContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
            
            
            localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                if success {
                    
                     alert.showAlert(title: "Success", message: "Awesome!!... User authenticated successfully.",buttonText: "Okay")
                    
                } else {
                    alert.showAlert(title: "Error", message: "Error occured",buttonText: "Okay")
                    
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        
                         alert.showAlert(title: "Error", message: messageToDisplay,buttonText: "Okay")
                        
                    }
                }
            }
            
        } else {
            
             alert.showAlert(title: "Error", message: "User has not enrolled into using Biometricsd",buttonText: "Okay")
            
        }
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
    
    func getErrorDescription(errorCode: Int) -> String {
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            return "Authentication was not successful, because user failed to provide valid credentials."
            
        case LAError.appCancel.rawValue:
            return "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
            
        case LAError.invalidContext.rawValue:
            return "LAContext passed to this call has been previously invalidated."
            
        case LAError.notInteractive.rawValue:
            return "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property."
            
        case LAError.passcodeNotSet.rawValue:
            return "Authentication could not start, because passcode is not set on the device."
            
        case LAError.systemCancel.rawValue:
            return "Authentication was canceled by system (e.g. another application went to foreground)."
            
        case LAError.userCancel.rawValue:
            return "Authentication was canceled by user (e.g. tapped Cancel button)."
            
        case LAError.userFallback.rawValue:
            return "Authentication was canceled, because the user tapped the fallback button (Enter Password)."
            
        default:
            return "Error code \(errorCode) not found"
        }
        
    }

}
