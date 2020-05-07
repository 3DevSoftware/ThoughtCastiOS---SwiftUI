//
//  SavedDrawingsViewController.swift
//  slate
//
//  Created by Sanira on 7/19/17.
//  Copyright © 2017 ma. All rights reserved.
//

import UIKit
import DKPhotoGallery

class SavedDrawingViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DKPhotoGalleryDelegate {
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    var drawings = SavedDrawings()
    var selectionMode = false
    let sellId = "SavedImageCell"
   var loaded = false
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cellWidth: CGFloat!
    var proportion: CGFloat!
    var cellHeight: CGFloat!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
   
        
 
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    

    //MARK:- overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsMultipleSelection = true
        collectionView?.flashScrollIndicators()
        loadDrawings()
        collectionView.allowsSelection = true
  collectionView.dataSource = self
        collectionView.delegate = self
        
        print("testing : \(drawings.collection.count)")
   
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        
    }
    
    func loadDrawings() {
        drawings.collection = []
        let album = CustomPhotoAlbum()
        
        
        album.loadSavedDrawings(setDrawings, errorHandler: showErrorAlert)
    }
    


    
    
    

    override func viewDidLayoutSubviews() {
   collectionView?.allowsMultipleSelection = true
        collectionView.allowsSelection = true
      
  if(!loaded)
  {
        screenWidth = self.collectionView.frame.width
        screenHeight = self.collectionView.frame.height
        cellWidth = (screenWidth - 40) / 3
        proportion = screenHeight / screenWidth
        cellHeight = cellWidth * proportion + 40
        loaded = true
        }
}
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("WTFFF")
        
        if !selectionMode {
            
            
            var items = [DKPhotoGalleryItem]()
            
            for item in drawings.collection
            {
                items.append(DKPhotoGalleryItem(image: item.drawingImage))
            }
            let gallery = DKPhotoGallery()
            gallery.singleTapMode = .dismiss
            
            gallery.items = items
            
            
            gallery.presentationIndex = indexPath.row
            
            gallery.galleryDelegate = self;
            self.present(photoGallery: gallery)
            
            
            

            return
        }
        
        self.drawings.collection[indexPath.row].isSelected = true
        
        let cell = collectionView.cellForItem(at: indexPath) as! SavedImageCell
        cell.select()
        cell.setSelection(true)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("DESELECTED?")
        guard selectionMode else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! SavedImageCell
        
        cell.deselect()
        self.drawings.collection[indexPath.row].isSelected = false
        cell.setSelection(false)
        
    }
    
    
    
    func photoGallery(_ gallery: DKPhotoGallery, didShow index: Int)
    {
        print("******************** photoGallery: \(index)");
    }
    
    func setDrawings (drawings: [SavedDrawing]){
        DispatchQueue.main.async {
            self.drawings.collection = drawings
            self.collectionView.reloadData()

        }
    }
    
    @IBAction func goHomeClicked() {
        self.navigationController?.popViewController(animated: false);
//      performSegue(withIdentifier: "goBackHome", sender: nil)
    }
    
    

    
    
    @IBAction func selectClicked() {
        
 
        
        selectionMode = !selectionMode
        sendButton.isHidden = !selectionMode
        if selectionMode {
            selectButton.setTitle("Deselect", for: .normal)
        } else {
            drawings.deleselectAllDrawings()
            
            let selectedItems = collectionView.indexPathsForSelectedItems
            for indexPath in selectedItems! {
                collectionView.deselectItem(at: indexPath, animated:true)
            }
            
            selectButton.setTitle("Select", for: .normal)
        }
        deleteButton.isHidden = false
        collectionView.reloadData()
    }
    
    @IBAction func sendSelectedClicked() {
        guard drawings.selectedImages.count != 0 else {
            return
        }
        let imagesToShare = drawings.selectedImages
        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteClicked() {
        if !selectionMode {
            removeAll()
            return
        }
        guard drawings.selectedAssets.count != 0 else {
            return
        }
        
        removeSelectedDrawings()
        
        
     
  self.collectionView.reloadData()
      
        
    }
    
    func removeAll() {
        let album = CustomPhotoAlbum()
        album.removeDrawings(assets: drawings.allAssets as NSArray, successCompletion: {
            self.clear()
        }, errorHandler: showErrorAlert)
    }
    
    func removeSelectedDrawings() {
        let album = CustomPhotoAlbum()
        
        print("Count before: \(drawings.collection.count)")
        album.removeDrawings(assets: drawings.selectedAssets as NSArray, successCompletion: {
            if self.drawings.selectedAssets.count ==
                self.drawings.collection.count {
                self.clear()
            } else {
              
             
                
              self.loadDrawings()
              
                
                
                  print("Count before: \(self.drawings.collection.count)")
                
            }
            
      
        }, errorHandler: showErrorAlert)
      
        
        
        
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("this shuold work: \(drawings.collection.count)")
        return drawings.collection.count
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        print("TAPPED")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sellId, for: indexPath) as! SavedImageCell
        
        let cellRect = cell.contentView.convert(cell.contentView.bounds, to: collectionView.coordinateSpace)
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        
        print("testing: \(cellRect) \(collectionView.frame.height)")
        
        
        cell.setData(drawing: drawings.collection[indexPath.row])
        
        if(selectionMode)
        {
            if(self.drawings.collection[indexPath.row].isSelected)
            {
                //self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                cell.select()
                print("THIS PART SELECTED IT!")
            }
            else
            {
                
                cell.deselect()
                
            }
        }
        else
        {
            cell.deselectBoolean = false
        }
        self.collectionView.deselectItem(at: indexPath, animated: false)
        cell.setSelection(selectionMode)
        
        
        
        return cell
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.drawings.collection = []
            self.collectionView.reloadData()
        }
    }
}





