//
//  User.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 20/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//
import SwiftyJSON
import UIKit

class User{
    
    var id: Int
    var email: String
    var cover_photo:String
    var profile_photo:String
    
    init(){
        self.id = 0
        self.email = ""
        self.cover_photo = ""
        self.profile_photo = ""
    }
    
    
    init(Id: Int){
        self.id = Id
        self.id = 0
        self.email = ""
        self.cover_photo = ""
        self.profile_photo = ""
        
        let postData = "id=\(id)".dataUsingEncoding(NSASCIIStringEncoding);
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Globals.API_URL+"service/user.php")!)
        
        
        let postLength:NSString = String(postData!.length)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                return
            }
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                if httpResponse.statusCode == 200{
                    let json = JSON(data: data!)
                    
                    self.id = json["id"].intValue
                    self.email = json["email"].stringValue
                    self.cover_photo = json["cover_photo"].stringValue
                    self.profile_photo = json["profile_photo"].stringValue
                    
                    return
                }else{
                    return
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func update(usersInfo: [String] ){
       
    
    }
    
    func create(){
        
    }
}
