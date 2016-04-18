//
//  BSGalleryViewController.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/8/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSGalleryViewController: BSViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var gallery: UICollectionView!
    
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gallery!.backgroundColor = UIColor.clearColor()
        gallery!.registerClass(BSPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        BSPhotoAlbum.sharedInstance.getAllPhotos { images in
            self.images = images.reverse()
        }

    }
    
    // MARK: - UICollectionViewDataSource protocol
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! BSPhotoCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        dispatch_async(dispatch_get_main_queue()) {
            cell.imageView?.image = self.images[indexPath.row]
        }

        return cell
    }

    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = UIScreen.mainScreen().bounds.width;
        let itemwidth = width/3 - 2;
        let itemheight = itemwidth - 10;
        
        return CGSizeMake(itemwidth, itemheight);
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
