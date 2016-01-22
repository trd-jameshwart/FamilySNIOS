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

class SettingsVC: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ProFileImage: UIImageView!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        self.tabBarItem.selectedImage = UIImage(named: "Settings_w")?.imageWithRenderingMode(.AlwaysOriginal)

        self.tableView.separatorColor = UIColor.clearColor()
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
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("profileTapped:"))
        self.ProFileImage.userInteractionEnabled = true
        self.ProFileImage.addGestureRecognizer(tapGestureRecognizer)
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
            self.setProfilePicture("photo_library")
            
        })

        let ActionTakePhoto = UIAlertAction(title: "Take a photo", style: .Default, handler: {
            (action: UIAlertAction) in
 
            print("Take a photo")
            self.setProfilePicture("camera")
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
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

    func uploadImageChoosen(){
        if let userid = NSUserDefaults.standardUserDefaults().stringForKey("user_id") {
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Globals.API_URL+"/service/image.php")!)
            print(userid)
            request.HTTPMethod = "POST"
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
            
            let imageData = UIImageJPEGRepresentation(self.ProFileImage.image!, 1)
            
            if imageData == nil{
                return
            }
            let param = [
                "firstName"  : "Felman",
                "userId"  : userid
            ]
            
            
            
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
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
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
        
    }
    
    private func setProfilePicture(whereStr: String){
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        if whereStr == "camera"{
           
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            
        } else if whereStr == "photo_library"{
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }else{
            imagePickerController
        }
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       print("\(indexPath.section)  ===== \(indexPath.row)  ")
        //Account Section
        if indexPath.section == 0{
        
            if indexPath.row == 2{
                
                logOut()
            }
        }
        //let cell = tableView.deq
    }
//    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//      
////        let bgColorView = UIView()
////        bgColorView.backgroundColor = UIColor.whiteColor()
////        cell.selectedBackgroundView = bgColorView
//        
//        if (cell.respondsToSelector(Selector("tintColor"))){
//            
//            if (tableView == self.tableView) {
//                
//                let cornerRadius : CGFloat = 12.0
//                cell.backgroundColor = UIColor.clearColor()
//                let layer: CAShapeLayer = CAShapeLayer()
//                let pathRef:CGMutablePathRef = CGPathCreateMutable()
//                let bounds: CGRect = CGRectInset(cell.bounds, 25, 0)
//                var addLine: Bool = false
//                
//                if (indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
//                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
//                } else if (indexPath.row == 0) {
//                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
//                    addLine = true
//                    
//                } else if (indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
//                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
//                    
//                } else {
//                    CGPathAddRect(pathRef, nil, bounds)
//                    addLine = true
//                    
//                }
//                
//                layer.path = pathRef
//                layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).CGColor
//                
//                if (addLine == true) {
//                    let lineLayer: CALayer = CALayer()
//                    let lineHeight: CGFloat = (1.0 / UIScreen.mainScreen().scale)
//                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight)
//                    lineLayer.backgroundColor = tableView.separatorColor!.CGColor
//                    layer.addSublayer(lineLayer)
//                }
//                
//                let testView: UIView = UIView(frame: bounds)
//                testView.layer.insertSublayer(layer, atIndex: 0)
//                testView.backgroundColor = UIColor.clearColor()
//                cell.backgroundView = testView
//                
//                let selectedLayer = CAShapeLayer()
//                selectedLayer.path = CGPathCreateCopy(pathRef)
//                selectedLayer.fillColor = UIColor(white: 0.75, alpha: 0.8).CGColor
//                let selectedView = UIView(frame: bounds)
//                selectedView.layer.insertSublayer(selectedLayer, atIndex: 0)
//                selectedView.backgroundColor = UIColor.clearColor()
//                cell.selectedBackgroundView = selectedView
//                
//            }
//        }
//    }
    
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
