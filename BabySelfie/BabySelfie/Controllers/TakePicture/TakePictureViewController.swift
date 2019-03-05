//
//  TakePictureViewController.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-27.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController {

    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var viewPicture: UIView!
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var takeOtherButton: UIButton!
    var openCamera: Bool = false
    
    var captureSession : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.askPermission()
        
        if (!self.openCamera) {
            self.openCamera = true
            if (previewLayer == nil) {
                return
            }
            previewLayer!.frame = previewView.bounds
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        } else {
            captureSession.startRunning()
        }
        
    }
    
    // MARK: - Methods

    func configure() {
        
        self.viewPreview.isHidden = true
        self.viewPicture.isHidden = false
        
        self.confirmButton.setTitle(NSLocalizedString("btn_confirm", comment: ""), for: .normal)
        self.takeOtherButton.setTitle(NSLocalizedString("btn_takeother", comment: ""), for: .normal)

    }
    
    func startCamera() {
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        if let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) {
            
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                
                if (captureSession.canAddOutput(cameraOutput)) {
                    captureSession.addOutput(cameraOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = previewView.bounds
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    
                    previewView.clipsToBounds = true
                    previewView.layer.addSublayer(previewLayer)
                    
                    captureSession.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    func askPermission() {
        
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraPermissionStatus {
        case .authorized:
            print("Already Authorized")
            self.startCamera()
            
        case .denied:
            print("denied")
            self.showAlert(NSLocalizedString("camera_permission_title", comment: ""), message: NSLocalizedString("camera_permission_text", comment: ""))
            
        case .restricted:
            print("restricted")
            
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                
                if granted == true {
                    // User granted
                    print("User granted")
                    DispatchQueue.main.async(){
                        self!.startCamera()
                    }
                }
                else {
                    // User Rejected
                    print("User Rejected")
                    DispatchQueue.main.async(){
                        self!.showAlert(NSLocalizedString("camera_rejected_title", comment: ""), message: NSLocalizedString("camera_rejected_text", comment: ""))
                    }
                }
            });
        }
    }

    // MARK: - Buttons
    
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
            ] as [String : Any]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    @IBAction func takeOtherButtonPressed(_ sender: Any) {
        
        self.viewPreview.isHidden = true
        self.viewPicture.isHidden = false
        
        captureSession!.startRunning()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        let menu:MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuView") as! MenuViewController;
        DispatchQueue.main.async {
            self.present(menu, animated: true, completion: nil)
        }
    }
    
}

extension TakePictureViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("error occured : \(error.localizedDescription)")
        }
        
        if let dataImage = photo.fileDataRepresentation() {
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
            
            self.capturedImage.image = image
            
            self.viewPreview.isHidden = false
            self.viewPicture.isHidden = true
            
        } else {
            print("some error here")
        }
    }
    
}
