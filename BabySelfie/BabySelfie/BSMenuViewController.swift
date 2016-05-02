//
//  BSMenuViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/11/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import Firebase

class BSMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTable: UITableView!
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var photoUser: UIImageView!
    
    var array = NSMutableArray()
    
    // MARK: Properties
    let ref = Firebase(url:FirebaseUrl)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.array = [["icon" : "icon_frequence", "title" : "Definir novo período \nde lembrete"],
                      ["icon" : "icon_video", "title" : "Reproduzir vídeo"],
                      ["icon" : "icon_fotos", "title" : "Apagar todas \nas fotos"],
                      ["icon" : "icon_perfil", "title" : "Mudar informações \npessoais"]]
        
        self.photoUser.layer.cornerRadius = self.photoUser.frame.size.height/2
        self.photoUser.layer.masksToBounds = true
        self.photoUser.layer.borderWidth = 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.boolForKey("login")) {
            
            let name = userDefaults.valueForKey("userName") as? String
            if(name != nil) {
                self.nameUser.text = name
            }
            
            
            let picture = userDefaults.valueForKey("userPhoto") as? String
            if (picture != nil) {
                let url = NSURL(string: picture!)
                let data = NSData(contentsOfURL: url!)
                self.photoUser.image = UIImage(data: data!)
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemMenuCell", forIndexPath: indexPath) as! BSItemMenuTableViewCell
        
        let dictionary = self.array[indexPath.row]
        cell.title.text = dictionary.objectForKey("title") as? String
        cell.icon.image = UIImage (named: (dictionary.objectForKey("icon") as? String)!)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print("You selected cell #\(indexPath.row)!")
        
        if (indexPath.row == 0) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true) {
                    NSNotificationCenter.defaultCenter().postNotificationName("OpenFrequence", object: nil)
                }
            })
            
        } else if (indexPath.row == 1) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true) {
                    NSNotificationCenter.defaultCenter().postNotificationName("OpenVideo", object: nil)
                }
            })
            
        } else if (indexPath.row == 2) {
            
            BSPhotoAlbum.sharedInstance.deleteAllPhotos({ (result) in
                if (result) {
                    
                    let ac = UIAlertController(title: "Atenção", message: "Fotos removidas com sucesso!", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            })
            
        } else if (indexPath.row == 3) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true) {
                    NSNotificationCenter.defaultCenter().postNotificationName("OpenEdit", object: nil)
                }
            })
            
        }
        
    }

    @IBAction func changePhotoUser(sender: AnyObject) {
        
        /*
         let userDefaults = NSUserDefaults.standardUserDefaults()
         userDefaults.setValue("", forKey: "photoUser")
         userDefaults.synchronize()
         */
        
    }
    
    @IBAction func actLogOut(sender: AnyObject) {
        
        let refreshAlert = UIAlertController(title: "Atenção", message: "Deseja fazer o Log Out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Sim", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.ref.unauth()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(false, forKey: "login")
            userDefaults.synchronize()
            
            self.dismissViewControllerAnimated(true) {
                NSNotificationCenter.defaultCenter().postNotificationName("BackLogin", object: nil)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Não", style: .Default, handler: nil))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func closeMenu(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
