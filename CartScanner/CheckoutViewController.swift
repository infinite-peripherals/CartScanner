//
//  CheckoutViewController.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit
import CoreData

class CheckoutViewController: UIViewController {

    
    @IBOutlet weak var qrCodeImage: UIImageView!
    var cartList: Array<AnyObject> = []
    
    @IBOutlet weak var webView: UIWebView!
    var theCart = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        var urlString: String = ""
 
        for (var i=0; i<cartList.count; i++){
            let strFunc = cartList[i].valueForKey("upc") as String
            urlString += "\(strFunc)!"
        }
        
        println(urlString)
        
        let url = NSURL (string: "http://api.qrserver.com/v1/create-qr-code/?data=\(urlString)&size=250x250");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
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
