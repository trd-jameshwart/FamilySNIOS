//
//  SettingsVC.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 11/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import UIKit
import QuartzCore
import Kingfisher

class SettingsVC: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var ProFileImage: UIImageView!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnCancelPassword: UIButton!
    
    override func viewDidLoad() {
        self.tabBarItem.selectedImage = UIImage(named: "Settings_w")?.imageWithRenderingMode(.AlwaysOriginal)

        //self.tableView.separatorColor = UIColor.clearColor()
            let defaults = NSUserDefaults.standardUserDefaults()
            if let coverPhoto = defaults.stringForKey("user_cover_photo") {
                print(coverPhoto)
                self.ProFileImage.kf_setImageWithURL(NSURL(string: coverPhoto)!, placeholderImage: nil)
                self.ProFileImage.layer.cornerRadius = self.ProFileImage.frame.size.width / 2
                self.ProFileImage.clipsToBounds = true
                //self.ProFileImage.layer.borderWidth = 3.0
                self.ProFileImage.layer.borderColor = UIColor.grayColor().CGColor
            }
        
        if let emailText = defaults.stringForKey("user_email"){
            self.lblEmail.text = emailText
            self.txtEmail.text = emailText
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("profileTapped:"))
        self.ProFileImage.userInteractionEnabled = true
        self.ProFileImage.addGestureRecognizer(tapGestureRecognizer)
        
        self.txtEmail.hidden = true
        self.txtEmail.delegate = self
        self.btnCancel.hidden = true
        
        
        self.txtPassword.hidden = true
        self.txtPassword.delegate = self
        self.btnCancelPassword.hidden = true
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyBoard"))
//        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelUpdatePassword(sender: AnyObject) {
        self.txtPassword.hidden = true
        self.btnCancelPassword.hidden = true
        self.lblPassword.hidden = false
        self.view.endEditing(true)
    }
    
    @IBAction func cancelUpdateEmailTapped(sender: AnyObject) {
        self.txtEmail.hidden = true
        self.btnCancel.hidden = true
        self.lblEmail.hidden = false
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if let userId = defaults.stringForKey("user_id"){
        
            self.view.endEditing(true)
        
            let email = self.txtEmail.text!
            let strUrl = Globals.API_URL+"/service/user.php"
            
            var param = [
                "id"        : userId,
                "email"     : email
            ]
            //If Email is the textfield
            if 1 == textField.tag {
                
                self.txtEmail.resignFirstResponder()
                self.txtEmail.hidden = true
                self.btnCancel.hidden = true
                self.lblEmail.hidden = false
                self.lblEmail.text = self.txtEmail.text
                
            //If Password is the textfield
            }else if 2 == textField.tag {
                self.txtPassword.resignFirstResponder()
                self.txtPassword.hidden = true
                self.btnCancelPassword.hidden = true
                self.lblPassword.hidden = false
                
                let password = self.txtPassword.text!
                param = [
                    "id"        : userId,
                    "password"  : password
                ]
            }
            
            let request = HttpRequest(url: strUrl, postData: param).getRequest()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
               data, response, error in
                
                if error != nil{
                  return
                }
                
                if let httpResponse = response as? NSHTTPURLResponse{
                
                    if httpResponse.statusCode == 200{
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                            
                            if let result = json["result"] as? Bool{
                                print(result)
                                if (result == true){
                                 print(self.lblEmail.text!)
                                }
                                                
                            }
                                            
                        } catch let err as NSError {
                        print("JSON error: \(err.localizedDescription)")
                        }
                    }
                }
                

            }
            
            task.resume()
        }
        
        print("Saving textfield data should be here")
        return true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        print("touchesBegan")
    }
    
    func dismissKeyBoard(){
            view.endEditing(true)
    }
    
    func emailTapped(sender: AnyObject){
        print("Email tapped")
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.ProFileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        uploadImageChoosen()
    }
    
    func profileTapped(img:AnyObject){
        print("Profile image tapped")
        let profileAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let ActionUploadFromLibrary = UIAlertAction(title: "Upload from Library", style: .Default, handler: {
            (action: UIAlertAction) in
            
            print("Upload from Library")
            self.selectImage("photo")
            
        })

        let ActionTakePhoto = UIAlertAction(title: "Take a photo", style: .Default, handler: {
            (action: UIAlertAction) in
 
            print("Take a photo")
            self.selectImage("camera")
        })
        
        let ActionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (action: UIAlertAction) in
            print("Cancel")
        })
        
        profileAlertController.addAction(ActionUploadFromLibrary)
        profileAlertController.addAction(ActionTakePhoto)
        profileAlertController.addAction(ActionCancel)
        
        self.presentViewController(profileAlertController, animated: true, completion: nil)
    }
    
    

    func uploadImageChoosen(){
        if let userid = NSUserDefaults.standardUserDefaults().stringForKey("user_id") {
 
            print(userid)

            let imageData = UIImageJPEGRepresentation(self.ProFileImage.image!, 1)
            
            let postData = [
                "firstName" : "Felman",
                "file"      : JPEG(img: imageData!),
                "userId"    : userid
            ]
            
            let strUrl = Globals.API_URL+"/service/image.php"
       
            let requestData = HttpRequest(url: strUrl, postData: postData).getRequest()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(requestData){
                data, response, error in
                
                if error != nil{
                    return
                }
                
                // Print out reponse body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    print(json)
                } catch let err as NSError {
                    print("JSON error: \(err.localizedDescription)")
                }
                
            }
            
            task.resume()
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       print("\(indexPath.section)  ===== \(indexPath.row)  ")
        //Account Section
        if indexPath.section == 0{
        
            if indexPath.row == 1{
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                //Hide label Email and show textfield Email
                self.lblEmail.hidden = true
                self.txtEmail.becomeFirstResponder()
                self.txtEmail.hidden = false
                self.btnCancel.hidden = false
                
                
            } else if indexPath.row == 2{
                //Hide label Password and show textfield Email
                self.lblPassword.hidden = true
                self.txtPassword.becomeFirstResponder()
                self.txtPassword.hidden = false
                self.btnCancelPassword.hidden = false
            } else  if indexPath.row == 3{
                
                logOut()
            }
        }
        //let cell = tableView.deq
    }

    
    @IBAction func logOutTapped(sender: UIButton) {
        //Call Log Out
        logOut()
    }
    
    func logOut(){
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "user_id")
        
        let LoginVC: UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("Log_inVC")
        
        self.presentViewController(LoginVC, animated: true, completion: nil)
    }
}
