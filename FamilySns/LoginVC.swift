//
//  LoginVC.swift
//  FamilySns
//
//  Created by Jameshwart Lopez on 12/8/15.
//  Copyright © 2015 Minato. All rights reserved.
//

import UIKit
import SwiftyJSON
import UIColor_Hex_Swift

class LoginVC: UIViewController {

   
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnLogin.layer.cornerRadius = 5
//        btnLogin.layer.borderWidth = 1
        //let color:UIColor =  UIColor(rgba: "#026a34").CGColor //UIColor(hexString:"026a34")
        //btnLogin.layer.borderColor = UIColor.redColor().CGColor
        
        // Do any additional setup after loading the view.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait,UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signinTapped(sender: UIButton){
        //Authentication code here 
        
        let email = txtEmail.text! as NSString
        let pword = txtPassword.text! as NSString

        if email.isEqualToString("") && pword.isEqualToString(""){
            self.showAlertView("Login Error", message: "Please enter email and password.")
        }else if email.isEqualToString(""){
            self.showAlertView("Login Error", message: "Please enter email.")
        }else if pword.isEqualToString(""){
            self.showAlertView("Login Error", message: "Please enter password.")
        }else{
            
            
            let post = "email=\(email)&password=\(pword)"
            let url:NSURL = NSURL(string: Globals.API_URL+"/service/login.php")!
            
            
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)

            let postLength:NSString = String( postData.length )
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
                            self.showAlertView("Login failed", message: err.localizedDescription)
                        })

                    }

                    return
                }

                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200 {

                        let json = JSON(data: data!)
                        //print(json)
                        if json[0]["OK"] == true{

                            dispatch_async(dispatch_get_main_queue(), {
                                //self.performSegueWithIdentifier("goto_home", sender: self)
                                Globals.USER_ID = json[1]["id"].intValue
                                Globals.USER_Email = json[1]["email"].stringValue
                                Globals.USER_Profile = json[1]["profile_photo"].stringValue
                                Globals.USER_CoverPhoto = json[1]["cover_photo"].stringValue
                                
                                
                                //self.dismissViewControllerAnimated(true, completion: nil)
                                let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                print(Globals.USER_Email);
                                defaults.setObject(json[1]["id"].intValue, forKey: "user_id")
                                defaults.setObject(json[1]["email"].stringValue, forKey: "user_email")
                                defaults.setObject(json[1]["profile_photo"].stringValue, forKey: "user_profile_photo")
                                
                                defaults.setObject(json[1]["cover_photo"].stringValue, forKey: "user_cover_photo")
                               
                                self.performSegueWithIdentifier("go_home", sender: nil)
                            })

                        }else{
                            dispatch_async(dispatch_get_main_queue(),{
                                self.showAlertView("Signup failed", message: json["error"].stringValue)
                            })

                        }
                    }
                }
                

            }

            task.resume()
            
        }

    }


    func showAlertView(title: String, message: String ){
        let alertView: UIAlertController = UIAlertController()
        alertView.title = title
        alertView.message = message
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
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
