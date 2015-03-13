//
//  Product.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import Foundation


class Product{
    
    var name:String
    var quantity: Int
    var UPC:String
    var price:Double
    var imageReference:String
    
    
    
    init(){
        self.name = ""
        self.quantity = 0
        self.UPC = ""
        self.price = 0.0
        self.imageReference = ""
    }
    
    init(name: String, quantity: Int, UPC: String, price: Double, imageReference: String){
        self.name = name
        self.quantity = quantity
        self.UPC = UPC
        self.price = price
        self.imageReference = imageReference
    }
    
    
    func createProduct(name: String, quantity: Int, UPC: String, price: Double){
        self.name = name
        self.quantity = quantity
        self.UPC = UPC
        self.price = price
        
    }
    
    
}