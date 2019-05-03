


import UIKit
import Firebase
import SVProgressHUD



class LogInViewController: UIViewController {

  
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

   

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error == nil {
                print("Log in succesful")
                print(user)
                self.performSegue(withIdentifier: "goToChat", sender: nil)
                SVProgressHUD.dismiss()
            }
            else {
                print(error)
                SVProgressHUD.dismiss()
            }
        }
        
        
        
        
    }
    


    
}  
