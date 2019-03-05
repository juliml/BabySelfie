//
//  FrequenceViewController.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-27.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit
import CircleSlider
import UserNotifications

class FrequenceViewController: UIViewController {

    @IBOutlet var sliderView: UIView!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var frequenceValue:Float!
    
    private var circleSlider: CircleSlider! {
        didSet {
            self.circleSlider.tag = 0
        }
    }
    
    private var sliderOptions: [CircleSliderOption] {
        return [
            CircleSliderOption.barColor(UIColor(red: 162/255, green: 213/255, blue: 164/255, alpha: 1)),
            CircleSliderOption.thumbColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)),
            CircleSliderOption.trackingColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)),
            CircleSliderOption.startAngle(-90),
            CircleSliderOption.barWidth(20),
            CircleSliderOption.maxValue(12),
            CircleSliderOption.minValue(0)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkNotificationAuth()

    }
    
    // MARK: - Methods
    
    func configure() {
        
        self.frequenceValue = 0;
        self.circleSlider = CircleSlider(frame: self.sliderView.bounds, options: self.sliderOptions)
        self.circleSlider?.addTarget(self, action: #selector(FrequenceViewController.valueChange(_:)), for: .valueChanged)
        self.sliderView.addSubview(self.circleSlider!)
        
        self.questionLabel.text = NSLocalizedString("settings_title", comment: "")
        self.startButton.setTitle(NSLocalizedString("btn_start", comment: ""), for: .normal)
        
        self.descriptionLabel.text = NSLocalizedString("freq_day", comment: "")
        
    }
    
   @objc func valueChange(_ sender: CircleSlider) {
        switch sender.tag {
        case 0:
            self.frequenceValue = sender.value
            self.valueLabel.text = getFrequenceValue(sender.value)
            self.descriptionLabel.text = getFrequenceDesc(sender.value)
            
        default:
            break
        }
    }
    
    private func checkNotificationAuth() {
        
        let settings = UNUserNotificationCenter.current()
        
        settings.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                
                let ac = UIAlertController(title: NSLocalizedString("notification_title", comment: ""), message: NSLocalizedString("notification_text", comment: ""), preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                ac.addAction(UIAlertAction(title: NSLocalizedString("notification_settings", comment: ""), style: .default, handler: {(action:UIAlertAction!) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }))
                
                self.present(ac, animated: true, completion: nil)
                return
            }
        })
        
    }
    
    // MARK: - Buttons

    @IBAction func startButtonPressed(_ sender: Any) {
        
        self.checkNotificationAuth()
        
        if self.frequenceValue == 0 {
            showAlert(nil, message: NSLocalizedString("alert_frequence", comment: "") as String)
            return
        }
        
        ProfileManager.instance.saveFrequence(self.frequenceValue)

        //cancel all notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //create new notification
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createNotification()
        
        //open camera
        let takePicture:TakePictureViewController = self.storyboard!.instantiateViewController(withIdentifier: "TakePictureView") as! TakePictureViewController;
        self.navigationController?.pushViewController(takePicture, animated: true)
        
    }
    
}
