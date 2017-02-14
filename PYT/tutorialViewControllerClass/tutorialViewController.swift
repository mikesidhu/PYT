//
//  tutorialViewController.swift
//  PYT
//
//  Created by Niteesh on 01/08/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit


class tutorialViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var imageTutorial: UIImageView!
    
    @IBOutlet var finishBtn: UIButton!
    
    @IBOutlet var skipBtn: UIButton!
     var tutorials = NSArray()
    var index = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          let userdefaults = NSUserDefaults.standardUserDefaults()
         userdefaults.setBool(true, forKey: "tutorialLaunch")
        
        
      //  finishBtn.hidden=true
       
       // tutorials = ["url3","url4","url5"] as NSArray
        
       // imageTutorial.image=UIImage (named: tutorials .objectAtIndex(index) as! String )
        
      //  let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(tutorialViewController.swiped(_:))) // put : at the end of method name
      //  swipeRight.direction = UISwipeGestureRecognizerDirection.Right
       // self.view.addGestureRecognizer(swipeRight)
        
        
       // let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(tutorialViewController.swiped(_:))) // put : at the end of method name
      //  swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
       // self.view.addGestureRecognizer(swipeLeft)
        
        
    }
    
    /*
    
   //MARK:- Add swipe gesture on the imageview for effect
    
    
   func swiped(gesture: UIGestureRecognizer) {
    
    print(gesture)
    
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
        switch swipeGesture.direction {
            
        case UISwipeGestureRecognizerDirection.Right :
            print("User swiped right")
            finishBtn.hidden=true
            // decrease index first
            print(index)
            if index==0 {
            }
            else{
                index -= 1
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.5)
                let transition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                
                imageTutorial.layer.addAnimation(transition, forKey: kCATransition)
                imageTutorial.image=UIImage (named: tutorials .objectAtIndex(index) as! String )
                CATransaction.commit()
                print(index)
                
            }
            
        case UISwipeGestureRecognizerDirection.Left:
            print("User swiped Left")
            
            print(index)
            if index==tutorials.count-1 {
                
            }
            else{
                index+=1
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.5)
                let transition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                imageTutorial.layer.addAnimation(transition, forKey: kCATransition)
                imageTutorial.image=UIImage (named: tutorials .objectAtIndex(index) as! String )
                CATransaction.commit()
                //print(index)
                
                if index==tutorials.count-1 {
                    finishBtn.hidden=false
                }
                
                
            }
            
               
            
        default:
            break //stops the code/codes nothing.
            
            
        }
        
    }

    
    
    
    
    }

    
    @IBAction func finishAction(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier("afterLaunch", sender: self)
        
        
        
    }
    
   
    
    @IBAction func skipAction(sender: AnyObject) {
        
         self.performSegueWithIdentifier("afterLaunch", sender: self)
        
        
    }
    
 */
    
    
    
    
    
    
    

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
