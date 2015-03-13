//
//  AddToCartViewController.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//


// In this file, we need to search for the product’s price in the database in order to
// find the right product to add to cart

import UIKit



class AddToCartViewController: UIViewController{
    
    var scannerBarcode: String?
    var theProduct = Product()
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var scannedUPC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image : UIImage = UIImage(named:theProduct.imageReference)!
        productImage.image = image
        itemName.text = "\(theProduct.name)"
        scannedUPC.text = "Price: $\(theProduct.price)"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addToCart"{
        var productToPass = segue.destinationViewController as CartViewController
        productToPass.newProduct = self.theProduct
        }

    }
    

}
