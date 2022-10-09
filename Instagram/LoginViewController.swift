//
//  LoginViewController.swift
//  Instagram
//
//  Created by Cheng Xue on 10/6/22.
//

import UIKit
import Parse
import SnackBar_swift


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onSignUp(_ sender: Any) {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.signUpInBackground {(success, error)in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                SnackBar.make(in: self.view, message: "\(error?.localizedDescription)", duration: .lengthLong).show()
//                print("Error \(error?.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                SnackBar.make(in: self.view, message: "\(error?.localizedDescription)", duration: .lengthLong).show()
//                print("Error \(error?.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
