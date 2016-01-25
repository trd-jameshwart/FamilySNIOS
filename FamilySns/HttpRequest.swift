//
//  HttpRequest.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 22/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import Foundation

class HttpRequest{
    
    var httpType:String = "POST"
    
    var request:NSMutableURLRequest
    
    
    init(url: String,postData: String){


        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.request.HTTPMethod = self.httpType
        self.setUrlEncoded()
        self.accetpJSON()
        self.request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)!
        
    }
    
    init(url: String, postData:[String : String]?){
        
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
    
        let boundary = self.generateBoundary()
        self.request.HTTPMethod = self.httpType
        self.setMultipart(boundary)
        self.accetpJSON()
        self.request.HTTPBody = self.createRequestBody(postData,boundary: boundary)
        
    }

    init(url: String, postData: NSDictionary){
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.request.HTTPMethod = self.httpType

        let boundary = self.generateBoundary()
        self.setMultipart(boundary)
        self.accetpJSON()
        self.request.HTTPBody = self.createRequestBody(postData, boundary: boundary)
    }
    
    func createRequestBody(parameters: NSDictionary, boundary: String) -> NSMutableData{
        let body  = NSMutableData()
        
        for(key , value) in parameters{
            
            body.appendString("--\(boundary)\r\n")
            
            if value is String{
                
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
                
            }else if value is JPEG{
                
                let img = value as! JPEG
                
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(img.fileName)\"\r\n")
                body.appendString("Content-Type: \(img.mimeType)\r\n\r\n")
                body.appendData(img.imageData)
                body.appendString("\r\n")
                    
                
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
        
    }
    
    func createRequestBody(parameters: [String: String]?, boundary: String) -> NSMutableData{
        let body = NSMutableData()
        
        for(key, value) in parameters! {
        
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
            
        }

        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    
    func accetpJSON(){
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    
    func setMultipart(boundary: String){
        self.request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
    }
    
    func setUrlEncoded(){
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    
    
    func getRequest() -> NSMutableURLRequest{
        return self.request
    }
    
    private func generateBoundary() ->String{
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
