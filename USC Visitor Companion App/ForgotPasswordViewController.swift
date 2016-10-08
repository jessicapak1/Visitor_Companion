//
//  ForgotPasswordViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordAction(_ sender: AnyObject) {
        passwordReset()
    }
    
    func passwordReset() {
        let email = emailTextField.text
//        let finalEmail = email?.trimmingCharacters(in: NSCharacterSet.whitespaces)
//        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Send a request to reset a password
        if((emailTextField.text?.isEmpty)!)
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
        } else {
            PFUser.requestPasswordResetForEmail(inBackground: email!)
            let alertController = UIAlertController(title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + email! + ".", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
