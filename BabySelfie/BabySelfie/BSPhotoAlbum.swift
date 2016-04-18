//
//  BSPhotoAlbum.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/8/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import Photos

class BSPhotoAlbum: NSObject {

    static let albumName = "BabySelfie"
    static let sharedInstance = BSPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
        } else {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(BSPhotoAlbum.albumName)
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                }
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", BSPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject as! PHAssetCollection
        }
        return nil
    }
    
    func saveImage(image: UIImage, completion: (result: Bool) -> Void) {
        if assetCollection == nil {
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ 
            
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceHolder!])
            
        }) { (salvou, error) in
                completion(result: salvou)
        }
    }
    
    func saveVideo(url:NSURL, completion: (result: Bool) -> Void) {
        
        self.createAlbum()
        print(url)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(url)
                let assetPlaceHolder = assetChangeRequest!.placeholderForCreatedAsset
                
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                albumChangeRequest!.addAssets([assetPlaceHolder!])
                
            }, completionHandler: {(success, error)in
                print(error)
                completion(result: success)
            })
        })
        
    }
    
    
    func getAllPhotos(completion completionBlock : ([UIImage] -> ()))   {
        
        if assetCollection == nil {
            return
        }
        
        var images : [UIImage] = []
        var photoAssets = PHFetchResult()
        let imageManager = PHCachingImageManager()
        
        photoAssets = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
        
        photoAssets.enumerateObjectsUsingBlock{(object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                
                let options = PHImageRequestOptions()
                options.deliveryMode = .FastFormat
                options.synchronous = true
                
                var thumbnail = UIImage()
                imageManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFill, options: options, resultHandler: { (image, info) -> Void in
                    
                    thumbnail = image!
                    images.append(thumbnail)
                })
            }
        }
        
        completionBlock(images)
    }
    
    func deleteAllPhotos(completion: (result: Bool) -> Void) {
        
        if assetCollection == nil {
            return
        }
        
        var photoAssets = PHFetchResult()
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            photoAssets = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
            PHAssetChangeRequest.deleteAssets(photoAssets)
            
        }, completionHandler: {(success, error)in
            print(error)
            completion(result: success)
        })
        
    }
    
}
