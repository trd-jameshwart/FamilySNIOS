//
//  ViewController.swift
//  FamilySns
//
//  Created by Jameshwart Lopez on 12/8/15.
//  Copyright © 2015 Minato. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBAction func showAlertWasTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Appcoda", message: "Message in alert dialog", preferredStyle: UIAlertControllerStyle.ActionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(alert :UIAlertAction!) in
            print("Delete button tapped")
        })
        
        alertController.addAction(deleteAction)

        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(okAction)

        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(alertController, animated: true, completion: nil)


    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "popoverSegue"{
//            dispatch_async(dispatch_get_main_queue(), {
//                let popoverViewController = segue.destinationViewController
//                popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
//                popoverViewController.popoverPresentationController!.delegate = self
//            })

            let vc = PostModal()
            vc.modalPresentationStyle = .Popover
            presentViewController(vc, animated: true, completion: nil)
            vc.popoverPresentationController?.sourceView = view;
   //         vc.popoverPresentationController?.sourceRect =
        }


    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    override func viewWillAppear(animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //[self setModalPresentationStyle:UIModalPresentationCurrentContext];

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewDidAppear(animated: Bool) {
        //self.performSegueWithIdentifier("goto_login", sender: self)
    }
    @IBAction func profileTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_profile", sender: nil)
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }

//
//    func tableView(tableview: UITableView, numberOfRowsInSection section:Int)-> Int{
//
//    }
//
//    func tableview(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
//
//    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPaht indexPath:NSIndexPath){
//
//    }



}

