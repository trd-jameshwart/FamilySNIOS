//
//  ImagePicker.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 27/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import UIKit

extension UIImagePickerControllerDelegate where Self: UIViewController, Self: UINavigationControllerDelegate {
    func selectImage(from: String) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if("camera" == from){
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }else if("photo" == from){
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePickerController, animated:true, completion: nil)
    }
}