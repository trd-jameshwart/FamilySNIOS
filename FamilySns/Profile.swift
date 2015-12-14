//
//  Profile.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 12/10/15.
//  Copyright © 2015 Minato. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class Profile: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var myCoverPhoto: UIImageView!
//    let recognizer = UITapGestureRecognizer()
    @IBOutlet weak var myProfilePhoto: UIImageView!
    let recognizer = UITapGestureRecognizer()
    @IBOutlet weak var profileActiviyIndicator: UIActivityIndicatorView!

    var flag: String!
    
    override func viewDidLoad() {

        myCoverPhoto.kf_setImageWithURL(NSURL(string: Globals.API_URL+"/resources/sample_cover.jpg")!, placeholderImage: nil)
        myProfilePhoto.kf_setImageWithURL(NSURL(string: Globals.API_URL+"/resources/male-profile-user.png")!, placeholderImage: nil)
//        recognizer.addTarget(self, action: "profileImageTapped")
//        myProfilePhoto.addGestureRecognizer(recognizer)
        recognizer.addTarget(self, action: "profileImageTapped")
        myProfilePhoto.userInteractionEnabled = true
        myProfilePhoto.addGestureRecognizer(recognizer)
        roundedImageProfile()
    
    }
    
    @IBAction func profileImageTapped(){
        print("profile tapped")
        let profileAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let profileAlertActionUpload = UIAlertAction(title: "Upload from Library", style: .Default, handler: { (action: UIAlertAction) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.profileSelectFromGallery(self)
            });
        })
        
        let profileAlertActionTakePhoto = UIAlertAction(title: "Take photo", style: .Default, handler: { (action: UIAlertAction!) in
            print("Take Photo")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
               self.profileTakePhoto()
            });
        })
        
        let profileAlertActionExisting = UIAlertAction(title: "Existing photos", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Existing photos Logic here")
        })
        
        let profileAlertCancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancel")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        
        profileAlertController.addAction(profileAlertActionUpload)
        profileAlertController.addAction(profileAlertActionTakePhoto)
        profileAlertController.addAction(profileAlertActionExisting)
        profileAlertController.addAction(profileAlertCancel)
        
        presentViewController(profileAlertController, animated: true, completion: nil)
    }
//    
//    func profileImagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        myProfilePhoto.image = info[UIImagePickerControllerOriginalImage] as?UIImage
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
    internal func profileSelectFromGallery(sender: Profile){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = sender;
        myPickerController.sourceType =
            UIImagePickerControllerSourceType.PhotoLibrary
        self.flag="ProfilePhoto"
        sender.presentViewController(myPickerController, animated:true, completion: nil)
    }
    
    internal func profileTakePhoto(){
        let myPickerController2 = UIImagePickerController()
        myPickerController2.delegate = self;
        myPickerController2.sourceType =
            UIImagePickerControllerSourceType.Camera
        
        self.flag="ProfilePhoto"
        self.presentViewController(myPickerController2, animated:true, completion: nil)
    }

    

    @IBAction func editCoverButtonTapped(sender: AnyObject) {
        let coverAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        let coverAlertActionUpload = UIAlertAction(title: "Upload from Library", style: .Default, handler: { (action: UIAlertAction!) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.coverSelectFromGallery(self)
            });
        })

        let coverAlertActionTakePhoto = UIAlertAction(title: "Take photo", style: .Default, handler: { (action: UIAlertAction!) in
            print("Take Photo")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.coverTakePhoto()
            });
        })

        let coverAlertActionExisting = UIAlertAction(title: "Existing photos", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Existing photos Logic here")
        })
        
        let coverAlertCancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancel")
            self.dismissViewControllerAnimated(true, completion: nil)
        })

        coverAlertController.addAction(coverAlertActionUpload)
        coverAlertController.addAction(coverAlertActionTakePhoto)
        coverAlertController.addAction(coverAlertActionExisting)
        coverAlertController.addAction(coverAlertCancel)

        presentViewController(coverAlertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if self.flag == "CoverPhoto"{
            myCoverPhoto.image = info[UIImagePickerControllerOriginalImage] as?UIImage
        }else if self.flag == "ProfilePhoto"{
            myProfilePhoto.image = info[UIImagePickerControllerOriginalImage] as?UIImage
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func coverSelectFromGallery(sender: Profile){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = sender;
        myPickerController.sourceType =
            UIImagePickerControllerSourceType.PhotoLibrary
        self.flag = "CoverPhoto"
        sender.presentViewController(myPickerController, animated:true, completion: nil)
    }
    
    internal func coverTakePhoto(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =
            UIImagePickerControllerSourceType.Camera
        
        self.flag = "CoverPhoto"
        self.presentViewController(myPickerController, animated:true, completion: nil)
    }

    @IBAction func uploadButtonTapped(sender: AnyObject) {
        myImageUploadRequest()
    }
    
    func myImageUploadRequest(){
        let myUrl = NSURL(string: Globals.API_URL+"/service/image.php");

        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";

        let param = [
            "firstName"  : "Felman",
            "lastName"    : "Buntog",
            "userId"    : "9"
        ]

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        let imageData = UIImageJPEGRepresentation(myCoverPhoto.image!, 1)

        if(imageData==nil)  { return; }

        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)

        profileActiviyIndicator.startAnimating();

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error=\(error)")
                return
            }

            // You can print out response object
            print("******* response = \(response)")

            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")

                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                        print(json)
                } catch let err as NSError {
                    print("JSON error: \(err.localizedDescription)")
                }


            dispatch_async(dispatch_get_main_queue(),{
                self.profileActiviyIndicator.stopAnimating()
//                self.myImageView.image = nil;
            });

            /*
            if let parseJSON = json {
            var firstNameValue = parseJSON["firstName"] as? String
            println("firstNameValue: \(firstNameValue)")
            }
            */

        }

        task.resume()

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

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }


    func roundedImageProfile(){
        myProfilePhoto.layer.cornerRadius = myProfilePhoto.frame.size.width / 2
        myProfilePhoto.clipsToBounds = true
    }

}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

