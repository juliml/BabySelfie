//
//  BSFrequenceViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/5/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import CircleSlider

class BSFrequenceViewController: UIViewController {

    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var circleSlider: CircleSlider! {
        didSet {
            self.circleSlider.tag = 0
        }
    }
    
    private var sliderOptions: [CircleSliderOption] {
        return [
            .BarColor(UIColor(red: 162/255, green: 213/255, blue: 164/255, alpha: 1)),
            .ThumbColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)),
            .TrackingColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)),
            .StartAngle(-90),
            .BarWidth(2),
            .MaxValue(12),
            .MinValue(0)
        ]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buildCircleSlider()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //get frequence
        /*let userDefaults = NSUserDefaults.standardUserDefaults()
         if let frequence = userDefaults.valueForKey("frequence") {
         
         }*/
    }

    private func buildCircleSlider() {
        
        self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
        self.circleSlider?.addTarget(self, action: #selector(BSFrequenceViewController.valueChange(_:)), forControlEvents: .ValueChanged)
        self.sliderArea.addSubview(self.circleSlider!)
        
    }
    
    func valueChange(sender: CircleSlider) {
        switch sender.tag {
        case 0:
            self.valueLabel.text = "\(Int(sender.value))"
            if (Int(sender.value) > 1) {
                self.descLabel.text = "SEMANAS"
            } else {
                self.descLabel.text = "SEMANA"
            }
        default:
            break
        }
    }

    @IBAction func saveFrequence(sender: AnyObject) {
        
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Não é possível agendar", message: "Ou não temos permissão para agendar notificações, ou nós não pedimos ainda.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        
        let frequence = self.valueLabel.text
        
        if (Int(frequence!) > 0) {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(frequence, forKey: "frequence")
            userDefaults.synchronize()
            
            //cancel all notification
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            
            //create new notification
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.createNotification()
            
            let takePicture:BSTakePictureViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewTakePicture") as! BSTakePictureViewController;
            self.navigationController?.pushViewController(takePicture, animated: true)
            
        } else {
            
            let ac = UIAlertController(title: "Não é possível agendar", message: "Selecione a frequência das fotos!", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
