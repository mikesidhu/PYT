//
//  ReportProblemViewController.swift
//  PYT
//
//  Created by Niteesh on 09/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit

class ReportProblemViewController: UIViewController {

    
    
    @IBOutlet weak var reportButtonOutlet: UIButton!
    
    @IBOutlet weak var reportTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reportButtonOutlet.layer.cornerRadius=reportButtonOutlet.frame.size.height/2
        reportButtonOutlet.clipsToBounds=true
        
    }

    
    
    //MARK:- Back Action
    
    
    @IBAction func backAction(sender: AnyObject) {
        

        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    //Mark:- Report Button Action
    
    @IBAction func reportAction(sender: AnyObject) {
    
    
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
