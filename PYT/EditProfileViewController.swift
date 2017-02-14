//
//  EditProfileViewController.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    
    
    @IBOutlet weak var headerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
    
    self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    
        
        
        
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
