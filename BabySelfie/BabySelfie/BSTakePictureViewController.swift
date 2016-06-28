//
//  BSTakePictureViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/7/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import AVFoundation

class BSTakePictureViewController: BSViewController {

    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var viewPicture: UIView!
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewPhoto: UIView!
    
    var abriuCamera: Bool = false
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewPreview.hidden = true
        self.viewPicture.hidden = false
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPreset1280x720
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewPhoto.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession!.startRunning()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession!.stopRunning()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!self.abriuCamera) {
            self.abriuCamera = true
            if (previewLayer == nil) {
                return
            }
            previewLayer!.frame = previewPhoto.bounds
        }
        
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.capturedImage.image = image
                    
                    self.viewPreview.hidden = false
                    self.viewPicture.hidden = true
                }
            })
        }
        
    }

    @IBAction func takeAnotherPhoto(sender: AnyObject) {
        
        self.viewPreview.hidden = true
        self.viewPicture.hidden = false
        
        captureSession!.startRunning()
    }
    
    @IBAction func savePhoto(sender: AnyObject) {
        BSPhotoAlbum.sharedInstance.saveImage(self.capturedImage.image!) { (result) in
            if (result) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let gallery:BSGalleryViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewGallery") as! BSGalleryViewController;
                    self.navigationController?.pushViewController(gallery, animated: true)
                    
                })
                
            }
        }
        
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        let menu:BSMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("viewMenu") as! BSMenuViewController;
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(menu, animated: true, completion: nil)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
