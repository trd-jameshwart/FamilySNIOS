//
//  SettingsVC.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 11/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    override func viewDidLoad() {
        self.tabBarItem.selectedImage = UIImage(named: "Settings_w")?.imageWithRenderingMode(.AlwaysOriginal)
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
