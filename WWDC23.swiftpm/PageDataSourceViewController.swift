//
//  PageDataSourceViewController.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import UIKit
import SpriteKit

// Source: http://shrikar.com/ios-swift-tutorial-uipageviewcontroller-as-user-onboarding-tool/

class PageDataSourceViewController: UIViewController, UIPageViewControllerDataSource {
    
    fileprivate var pageController: UIPageViewController!
    
    fileprivate let pages = [
        "InstructionsPage0",
        "InstructionsPage1",
        "InstructionsPage2",
        "InstructionsPage3",
        "InstructionsPage4",
        "InstructionsPage5",
        "InstructionsPage6"]
    
    fileprivate let verticalOffset: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPageControl()
        
    }

//MARK: - Page View Controller methods
    
    fileprivate func createPageViewController() {
        
        pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController")
            as? UIPageViewController
        pageController.dataSource = self
        
        if pages.count > 0 {
            let firstController = getPageController(0)!
            
            pageController.setViewControllers([firstController],
                direction: UIPageViewController.NavigationDirection.forward,
                animated: false,
                completion: nil)
        }
        
        pageController.view.frame = CGRect(x: 0, y: verticalOffset,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height - verticalOffset)
        
        addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
    }
    
    fileprivate func setupPageControl() {
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.systemGray
        appearance.currentPageIndicatorTintColor = UIColor.systemBlue
        if #available(iOS 13.0, *) {
            appearance.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        
    }

    fileprivate func getPageController(_ index: Int) -> UIViewController? {
        
        if index < pages.count {
            
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: pages[index]) 
            
            if index >= 2 && index <= 5 {
                let exampleVC = viewController as! ExampleViewController
                exampleVC.page = index
            }
            
            return viewController
        }
        return nil
    }
    

//MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let id = viewController.restorationIdentifier {
            if let index = pages.firstIndex(of: id) {
                if index > 0 {
                    return getPageController(index-1)
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let id = viewController.restorationIdentifier {
            if let index = pages.firstIndex(of: id) {
                if index + 1 < pages.count {
                    return getPageController(index+1)
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
