//
//  CustomPhotoAlbum.swift
//  slate
//
//  Created by Sanira on 7/19/17.
//  Copyright © 2017 ma. All rights reserved.
//

import Foundation
import Photos

class CustomPhotoAlbum: NSObject {
    static let albumName = "ThoughtCast"
    static let sharedInstance = CustomPhotoAlbum()
    private var assetsCount: Int = 0
    var assetCollection: PHAssetCollection!
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            if let assetCollection = fetchAssetCollectionForAlbum() {
                self.assetCollection = assetCollection
                return
            }
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            if let assetCollection = fetchAssetCollectionForAlbum() {
                self.assetCollection = assetCollection
                return
            }
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    private func createAlbum() {
        
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(String(describing: error))")
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        assetsCount = collection.count
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    public func savex(image: UIImage) {
        if assetCollection == nil {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            
        }, completionHandler: { (success, error) in
            if success {
                print("completed withh success")
            }
            if (error != nil) {
                print("completed with error")
            }
            
        })
    }
    
    public func loadSavedDrawings(_ successCompletion: @escaping ([SavedDrawing])->(), errorHandler: @escaping (String)->())
    {
        var photoAssets = PHFetchResult<PHAsset>()
        var drawings: [SavedDrawing] = []
        guard assetCollection != nil else {
            successCompletion([])
            return
        }
        
        var phOptions = PHFetchOptions()
        
        phOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: phOptions)
        
        
        
        let imageManager = PHImageManager.default()
        photoAssets.enumerateObjects(using: { (asset, count, stop) in
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = true
           
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                let savedDrawing = SavedDrawing(image: image!, date: asset.creationDate!, asset: asset)
                
                drawings.append(savedDrawing)
                successCompletion(drawings)
                return;
            })
        })
    }
    
    
    public func removeDrawings(assets: NSArray, successCompletion: @escaping ()->(), errorHandler: @escaping (String)->()) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let enumeration: NSArray = assets
            PHAssetChangeRequest.deleteAssets(enumeration)
        },
                                               completionHandler: { success, error in
                                                if success {
                                                    successCompletion()
                                                    return
                                                }
                                                
                                                //if error != nil {
                                                //  errorHandler(error!.localizedDescription)
                                                //return
                                                //}
                                                //errorHandler("Error")
                                                return
        })
    }
}
