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
    //var theCart = ShoppingCart()
    
    var productDatabase = [Product(name: "Water bottle", quantity: 1, UPC: "123456789", price: 2.49, imageReference: "water-bottle"), Product(name: "Camera", quantity: 1, UPC: "987654321", price: 199.99, imageReference: "camera")]
    
    
    @IBOutlet weak var nameOfItem: UILabel!
    @IBOutlet weak var scannedUPC: UILabel!

    
//    func editCartDidFinish(controller: CartViewController,cart: ShoppingCart)
//    {
//        self.theCart = controller.currentCart
//        println("Did Finish")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theProduct = searchDatabase(scannerBarcode!, database: productDatabase)
        var image : UIImage = UIImage(named:theProduct.imageReference)!
        productImage.image = image
        scannedUPC.text = "UPC test: \(scannerBarcode!) is \(theProduct.name)"
        nameOfItem.text = "\(theProduct.name)"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchDatabase(searchBarcode: String, database: Array<Product>) -> Product{
        
        var toReturn = Product()
        
        for (var i=0; i<database.count; i++){
            if searchBarcode == database[i].UPC{
                toReturn = database[i]
            }
        }
        
        return toReturn
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addToCart"{
        var productToPass = segue.destinationViewController as CartViewController
        productToPass.newProduct = self.theProduct
        }

    }
    

}
