//
//  SignupVc.swift
//  FamilySns
//
//  Created by Jameshwart Lopez on 12/8/15.
//  Copyright © 2015 Minato. All rights reserved.
//

import UIKit


class SignupVc: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTapped(sender: AnyObject) {
    
        let email: NSString = txtEmail.text! as NSString
        let password: NSString = txtPassword.text! as NSString
        let confirmPassword: NSString = txtConfirmPassword.text! as NSString
        
        

        if(email.isEqualToString("") || password.isEqualToString("")){
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Signup failed"
            alertView.message = "Please enter email and password."
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
            
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }else if(!password.isEqual(confirmPassword)){
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Signup failed"
            alertView.message = "Password don't match."
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }else{
            
            let post = "email=\(email)&password=\(password)&c_password=\(confirmPassword)";
            NSLog("Post Data: %@", post)
            
            let url:NSURL = NSURL(string: Globals.API_URL+"/service/signup.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                }
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
//                do {
//                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//                        print(json)
//                    }
//                } catch let err as NSError {
//                    print(err.localizedDescription)
//                }
                
            }
            
            task.resume()            
        }
        
        
        
    }

    
    @IBAction func gotoLogin(sender: UIButton) {
      self.dismissViewControllerAnimated(true
        , completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
