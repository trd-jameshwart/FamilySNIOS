//
//  HomeVC.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 08/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//
import UIKit
//import Foundation

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        
        self.tabBarItem.selectedImage = UIImage(named: "Home_w")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBarItem.image = UIImage(named: "Home_g")?.imageWithRenderingMode(.AlwaysOriginal)
        
//        let color:UIColor =  UIColor(rgba: "#026a34") //UIColor(hexString:"026a34")
//        
////        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], forState: .Normal)
//        
//        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:color], forState: .Normal)
        

    }
}