//
//  PageContentViewController.swift
//  GoNoGo
//
//  Created by Ismael on 7/26/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newController("Main",page: "Camera"),
            self.newController("GoNoGo",page: "GoNoGo"),
            self.newController("Main",page: "Profile"),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else
        {
            return self.orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else
        {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return self.orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    private func newController(storyBoard:String,page: String) -> UIViewController {
        return UIStoryboard(name: storyBoard, bundle: nil) .
            instantiateViewControllerWithIdentifier("\(page)ViewController")
    }
    
    
}
