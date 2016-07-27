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
        return [self.newController("Camera"),
                self.newController("Profile"),
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
     return viewController
    }
    
   func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
   {
     return viewController
    }
    
    private func newController(page: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(page)ViewController")
    }
}
