//
//  FriendsVC.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 11/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController {

    override func viewDidLoad() {
        self.tabBarItem.selectedImage = UIImage(named: "Friends_w")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBarItem.image = UIImage(named: "Friends_g")?.imageWithRenderingMode(.AlwaysOriginal)
    }
   
}
