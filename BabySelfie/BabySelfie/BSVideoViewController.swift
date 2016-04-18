//
//  BSVideoViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/12/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit
import SwiftLoader
import AssetsLibrary

class BSVideoViewController: UIViewController {
    
    var images : [UIImage] = []
    var urlVideo : NSURL = NSURL()
    
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnCompartilhar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.btnCancelar.hidden = true
        self.btnCompartilhar.hidden = true
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .whiteColor()
        config.foregroundColor = .clearColor()
        config.backgroundColor = .clearColor()
        config.titleTextColor = .whiteColor()
        
        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Carregando vídeo...", animated: true)
        
        BSPhotoAlbum.sharedInstance.getAllPhotos { images in
            self.images = images.reverse()
            self.createVideo()
        }
        
    }
    
    func createVideo() {
        
        if (self.images.count == 0) {
            
            let ac = UIAlertController(title: "Atenção", message: "Não existem imagens para gerar o vídeo.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.navigationController?.popViewControllerAnimated(true)
            }))
            presentViewController(ac, animated: true, completion: nil)
              
            
        } else {
            
            let image = self.images[0]
            
            let settings:NSDictionary = CEMovieMaker.videoSettingsWithCodec(AVVideoCodecH264, withWidth: image.size.width, andHeight: image.size.height)
            
            let prova = CEMovieMaker(settings: settings as [NSObject : AnyObject])
            
            prova.createMovieFromImages(self.images, withCompletion: {(fileURL:NSURL!) in
                self.viewMovieAtURL(fileURL)
                self.urlVideo = fileURL!
                
                // Save movie in cameraRoll
                /*let library:ALAssetsLibrary = ALAssetsLibrary()
                library.writeVideoAtPathToSavedPhotosAlbum(fileURL, completionBlock: {(assetURL:NSURL!, error) in
                    if((error) != nil) {
                        println("Errore nel salvataggio del filmato %@",error)
                    }
                })*/
            })
        }
        
    }
    
    func viewMovieAtURL(fileURL:NSURL!)->Void {
        
        self.btnCancelar.hidden = false
        self.btnCompartilhar.hidden = false
        
        SwiftLoader.hide()
        
        let player = AVPlayer(URL: fileURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height - 180.0
        
        playerViewController.view.frame = CGRectMake(0, 60, width, height)
        self.view.addSubview(playerViewController.view)
        self.addChildViewController(playerViewController)
        
        player.play()
        
    }

    @IBAction func cancelVideo(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func shareVideo(sender: AnyObject) {
        
        let activityViewController = UIActivityViewController(
            activityItems: [self.urlVideo],
            applicationActivities: nil)
        
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
