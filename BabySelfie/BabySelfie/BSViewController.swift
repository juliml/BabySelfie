//
//  BSViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 3/31/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BSViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(animated: Bool) {

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(BSViewController.backLogin(_:)), name:"BackLogin", object: nil)
        center.addObserver(self, selector: #selector(BSViewController.openFrequence(_:)), name:"OpenFrequence", object: nil)
        center.addObserver(self, selector: #selector(BSViewController.openVideo(_:)), name:"OpenVideo", object: nil)
        center.addObserver(self, selector: #selector(BSViewController.openEdit(_:)), name:"OpenEdit", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: "BackLogin", object: nil)
        center.removeObserver(self, name: "OpenFrequence", object: nil)
        center.removeObserver(self, name: "OpenVideo", object: nil)
        center.removeObserver(self, name: "OpenEdit", object: nil)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backLogin(notification: NSNotification){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func openFrequence(notification: NSNotification){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let frequence:BSFrequenceViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewFrequence") as! BSFrequenceViewController;
        self.navigationController?.pushViewController(frequence, animated: true)
    }
    
    func openVideo(notification: NSNotification){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let video:BSVideoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewMakeVideo") as! BSVideoViewController;
        self.navigationController?.pushViewController(video, animated: true)
        
    }
    
    func openEdit(notification: NSNotification){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let edit:BSEditUserViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewEdit") as! BSEditUserViewController;
        self.navigationController?.pushViewController(edit, animated: true)
        
    }

}
