//
//  MainTabBarViewController.swift
//  PYT
//
//  Created by Niteesh on 08/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              self.tabBar.setValue(true, forKey: "_hidesShadow") //hide the line in tabbar
        
               // Do any additional setup after loading the view.
    }

    
    func tabBarController(aTabBar: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
//            // Disable all but the first tab.
//            return false
//        }
           print("---------------Its comes here------------------")
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
