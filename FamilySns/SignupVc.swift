//
//  SignupVc.swift
//  FamilySns
//
//  Created by Jameshwart Lopez on 12/8/15.
//  Copyright © 2015 Minato. All rights reserved.
//

import UIKit
import SwiftyJSON

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

    func showAlertView(title: String, message:String){
        let alertView:UIAlertController = UIAlertController()
        alertView.title = title
        alertView.message = message
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }

    @IBAction func signupTapped(sender: AnyObject) {
    
        let email: NSString = txtEmail.text! as NSString
        let password: NSString = txtPassword.text! as NSString
        let confirmPassword: NSString = txtConfirmPassword.text! as NSString

        
        if(email.isEqualToString("") || password.isEqualToString("")){

            self.showAlertView("Sigup failed", message: "Please enter email and password.")
            
        }else if(!password.isEqual(confirmPassword)){

            self.showAlertView("Signup failed", message: "Password don't match.")
        }else{
            
            let post = "email=\(email)&password=\(password)&c_password=\(confirmPassword)";
            //NSLog("Post Data: %@", post)
            
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

                    if let err = error{
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showAlertView("Signup failed", message: err.localizedDescription)
                        })
                        
                    }

                  return
                }
                
                if let httpResponse = response as? NSHTTPURLResponse{
                    if(httpResponse.statusCode == 200){

                        let json = JSON(data: data!)
                        if json["OK"] == true{

                            dispatch_async(dispatch_get_main_queue(), {
                                let MainVC:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle() ).instantiateViewControllerWithIdentifier("MainVC")
                                self.presentViewController(MainVC, animated: true, completion: nil)
                            })

                        }else if json["error"] != nil{
                          
                            dispatch_async(dispatch_get_main_queue(), {
                                self.showAlertView("Signup failed", message: json["error"].stringValue)
                            })
                            
                        }
                    }
                }



            }
            
            task.resume()            
        }

        
        
        
    }

//
//    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if "goto_home" == segue.identifier{
//            print("Please go to home")
//        }
//    }
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
