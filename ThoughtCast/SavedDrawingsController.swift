import UIKit

class SavedDrawingsController: UIPageViewController
{
    
     var pages: [UIViewController] = []
    
  var drawings = SavedDrawings()
    

    var savedDrawing: SavedDrawing?
    var drawingCount = 0
    var selectionMode = false
    var pageCount = 0

    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
      

        print("test: \(drawings.collection.count)")
        
        for i in 0..<drawings.collection.count {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScaledDrawingViewController") as! ScaledDrawingViewController!
            vc?.drawingCount = i
            vc?.setDrawing(drawings.collection[i])
            
            
            pages.append(vc!)
        }
        
   
       
            setViewControllers([pages[pageCount]], direction: .forward, animated: false, completion: nil)
        
    }
}

extension SavedDrawingsController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension SavedDrawingsController: UIPageViewControllerDelegate { }
