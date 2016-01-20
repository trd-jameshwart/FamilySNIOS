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

class SettingsVC: UITableViewController {
    
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
