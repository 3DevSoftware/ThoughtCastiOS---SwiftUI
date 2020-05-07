//
//  ScaledDrawingViewController.swift
//  slate
//
//  Created by Sanira on 7/19/17.
//  Copyright © 2017 ma. All rights reserved.
//

import UIKit

class ScaledDrawingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var scrollView: UIScrollView!
    var drawings = SavedDrawings()
    var pageCount = 0
    var savedDrawing: SavedDrawing?
    var drawingCount = 0
    var selectionMode = false
    var currentItemNumber = 0
    
    var JustLoaded = false
    func setDrawings (drawings: [SavedDrawing]){
        DispatchQueue.main.async {
            self.drawings.collection = drawings
           
        }
    }
    func loadDrawings() {
        drawings.collection = []
        let album = CustomPhotoAlbum()
        
        
        album.loadSavedDrawings(setDrawings, errorHandler: showErrorAlert)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drawings.collection.count
    }
    


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //    self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
        //    self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SavedCellCollectionViewCell
        
    
    cell.dateTimeLabel.text = drawings.collection[indexPath.row].creationDate.dateTimeText()
        cell.imageView.image = drawings.collection[indexPath.row].drawingImage
    
    cell.dateTimeLabel.backgroundColor = self.view.backgroundColor
 //   cell.dateTimeLabel.text = drawings.collection[indexPath.row].creationDate.dateTimeText()
 
    print("wtF??? \(drawings.collection.count)")
            return cell
}
    

        
 
        /*
         if !selectionMode {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScaledDrawingViewController") as! ScaledDrawingViewController!
        // vc?.drawingCount = indexPath.row
        // vc?.setDrawing(drawings.collection[indexPath.row])
       //  self.present(vc!, animated: true, completion: nil)
         return
         }
 */
    
    func snapToNearestCell(_ collectionView: UICollectionView) {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width
            
            if collectionView.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / 2 {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource  = self
        print("TESTING!!! \(pageCount)")

            
            
        
        
        currentItemNumber = self.pageCount
        
        
        collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override func viewDidLayoutSubviews() {
        
        if(!JustLoaded)
        {
        DispatchQueue.main.async {
            //self.collectionView.scrollToItem(at: IndexPath(item: self.pageCount, section: 0), at: [.centeredHorizontally], animated: true)
            
            
            let indexPath = IndexPath(row: self.pageCount, section: 0)
            
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            // self.collectionView.layoutSubviews() // **Without this effect wont be visible**
            
            }
            JustLoaded = true
            
        }
        
        
    }
    
    
    @IBAction func pageControl(_ sender: UIPageControl) {
       
        print("modified")
        imageView.image = drawings.collection[sender.currentPage].drawingImage

        
    }
    
    func setDrawing(_ drawing: SavedDrawing) {
        self.savedDrawing = drawing
        
    }
    
    @IBAction func homeButtonClicked() {
        performSegue(withIdentifier: "backToSave", sender: nil)
    }
    
    
    @IBAction func deleteButtonClicked() {
        let album = CustomPhotoAlbum()
               print("DELETING #\(currentItemNumber)")
        album.removeDrawings(assets: [drawings.collection[self.currentItemNumber].asset] as NSArray, successCompletion: {
            self.drawings.collection.remove(at: self.currentItemNumber)
            
       
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: self.pageCount , section: 0), at: [.centeredHorizontally], animated: true)
                self.collectionView.reloadData()
                self.collectionView.layoutSubviews() // **Without this effect wont be visible**
                
                
                if(self.drawings.collection.count == 0)
                {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "Saved") as! SavedDrawingViewController
          
                  self.present(vc, animated: true, completion: nil)
                }
                
            }
 
           //
        }, errorHandler: showErrorAlert)
        
    
    }
    
    @IBAction func sendClicked() {
        let imagesToShare = [drawings.collection[self.currentItemNumber].drawingImage]
        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}


extension ScaledDrawingViewController: UICollectionViewDelegateFlowLayout
{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
  
    

    
}



extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

