//
//  CartViewController.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//
//  test HQ 
// more tests

import UIKit
import Foundation
import CoreData

protocol cartEditDelegate{
    func editCartDidFinish(controller: CartViewController,cart: ShoppingCart)
    
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var cartTableView: UITableView!
    
    var cartList: Array<AnyObject> = []
    
    var theCart = [NSManagedObject]()
    var newProduct = Product()

    @IBOutlet weak var totalLabel: UILabel!
    
    var delegate:cartEditDelegate? = nil
    
    
    @IBAction func clearCartPressed(sender: UIButton) {
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        self.totalLabel.text = "Total: $0.00"
        
        if let tv = cartTableView {
            
            var bas: NSManagedObject!
            
            for bas: AnyObject in cartList
            {
                context.deleteObject(bas as NSManagedObject)
            }
            
            cartList.removeAll(keepCapacity: false)
            tv.reloadData()
            context.save(nil)
            
        }
        
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(cartTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(cartTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:itemCell = cartTableView.dequeueReusableCellWithIdentifier("cell") as itemCell
        let item = theCart[indexPath.row]
        var price: Double = 0.0

        cell.itemName.text = item.valueForKey("name") as String?
        price = item.valueForKey("price") as Double!
        cell.itemPrice.text = "$\(price)"
        var imageName = item.valueForKey("image") as String?
        cell.itemImage.image = UIImage(named: imageName!)
            //cell.itemPrice.text =item.valueForKey("price") as Double?
        return cell
        
    }
    
    
    func tableView(cartTableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
            
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Cart")
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            if let tv = cartTableView{
                
                println(indexPath.row)
                context.deleteObject(cartList[indexPath!.row] as NSManagedObject)
                cartList.removeAtIndex(indexPath.row)
                self.cartTableView.beginUpdates()
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.cartTableView.endUpdates()
            }
            
            var totalPrice: Double = 0.0
            for (var i=0; i<cartList.count; i++){
                totalPrice += cartList[i].valueForKey("price") as Double!
            }
            
            self.totalLabel.text = "Total: $\(totalPrice)"
     
            var error: NSError? = nil
            if !context.save(&error){
                abort()
            }
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
        
    }
    
    
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.cartTableView.beginUpdates()
        self.cartTableView.insertRowsAtIndexPaths(theCart, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.cartTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.cartTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Register custom cell:
        var nib = UINib(nibName: "itemTableCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.saveItem(newProduct)

        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        var totalPrice: Double = 0.0
        
        for (var i=0; i<cartList.count; i++){
            totalPrice += cartList[i].valueForKey("price") as Double!
        }
        
        self.totalLabel.text = "Total: $\(totalPrice)"

        self.cartTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        //self.cartTableView.editing = true;
        self.cartTableView.reloadData()
        
        
        //println(theCart.count)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Begin save to Cart CoreData
    func saveItem(toAdd: Product) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Cart",
            inManagedObjectContext:
            managedContext)
        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        item.setValue(toAdd.name, forKey: "name")
        item.setValue(toAdd.price, forKey: "price")
        item.setValue(toAdd.quantity, forKey: "quantity")
        item.setValue(toAdd.imageReference, forKey: "image")
        item.setValue(toAdd.UPC, forKey: "upc")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        theCart.append(item)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Cart")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            theCart = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "backToScan" {
//            println("back to scan")
//            if (delegate != nil) {
//                delegate!.editCartDidFinish(self, cart: self.currentCart)
//            }
          //  var cartToPass = segue.destinationViewController as AddToCartViewController
            //cartToPass.theCart = self.currentCart
            //count = count + 1
            
            
      //  }
        
        //println(count)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   // }
    

}
