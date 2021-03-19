//
//  LoginViewController.swift
//  InstaPic
//
//  Created by My Mac on 3/9/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func onSignIn(_ sender: Any) {
        let userName = userNameTF.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
            if user != nil{
                self.userNameTF.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "loginToFeed", sender: nil)
            }else{
                print("error \(error!.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = userNameTF.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if let error = error{
                print("error \(error.localizedDescription)")
            }else{ //success
                self.userNameTF.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "loginToFeed", sender: nil)
            }
            
        }
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
