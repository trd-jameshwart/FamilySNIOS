//
//  JPEG.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 25/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import UIKit

class JPEG{

    let mimeType    = "image/jpg"
    let ext         = ".jpg"
    
    let fileName: String
    let imageData:NSData
    
    init(img: NSData){
        let dateStr = NSDate().time()
        
        self.fileName = "img_\(dateStr)"+self.ext
        self.imageData = img
    }
}
