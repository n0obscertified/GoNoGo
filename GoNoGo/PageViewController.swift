//
//  PageContentViewController.swift
//  GoNoGo
//
//  Created by Ismael on 7/26/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newController("Main",page: "Camera"),
            self.newController("GoNoGo",page: "GoNoGo"),
            self.newController("Main",page: "Profile"),
           ]
    }()
    

    var index = 0;
    
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
     if index > 0
     {
        index = index - 1
     }else{
        index = self.orderedViewControllers.count - 1
    }
    
     return  self.orderedViewControllers[index]
    }
    
   func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
   {
    if index < self.orderedViewControllers.count - 1
    {
        index += 1
    }else
    {
        index = 0
    }
    
     return self.orderedViewControllers[index]
    }
    
    private func newController(storyBoard:String,page: String) -> UIViewController {
        return UIStoryboard(name: storyBoard, bundle: nil) .
            instantiateViewControllerWithIdentifier("\(page)ViewController")
    }
    
    
}
