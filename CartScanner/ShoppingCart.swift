//
//  ShoppingCart.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import Foundation



class ShoppingCart {
    
    
    //var cartArray: Array<Product>
    var cartArray = [Product]()
    var saleTax = 9.25
    //var totalPrice:Double
    //var subTotal:Double
    var localSaleTax = 9.25
    
//    init(saleTax: Double, localSaleTax: Double){
//        
//        //self.cartArray = Array<Product>()
//        self.cartArray = [Product]
//        self.saleTax = 0.0
//        self.totalPrice = 0.0
//        self.subTotal = 0.0
//        self.localSaleTax = 0.075
//        
//    }
    
    
    func getCart()->Array<Product>{
        return self.cartArray
        
    }
    
//    func calculateSaleTax(){
//        saleTax = subTotal * localSaleTax
//    }
//    
//    
//    func calculateTotal(){
//        totalPrice = saleTax + subTotal
//    }
//    
//    func calculateSubtotal (){
//        var runningSubtotal = 0.0
//        for (var i=0; i<cartArray.count; i++){
//            runningSubtotal += cartArray[i].price
//            
//        }
//        
//        subTotal = runningSubtotal
//    }
    
    // func addItemToCart(currentItem: Product, currentQuantity: Int)
    func addItemToCart(currentItem: Product){
        //var hasDuplicate = false
        //for (var i=0; i<cartArray.count; i++){
        //  if cartArray[i].UPC == currentItem.UPC{
        //    hasDuplicate = true
        //  cartArray[i].quantity += currentQuantity
        //}
        // }
        
        //if !hasDuplicate{
        //currentItem.quantity = currentQuantity
        self.cartArray.append(currentItem)
        
        //}
        
        
        
    }
    
    
    func removeItem(upcString: String){
        for (var i=0; i<cartArray.count; i++){
            if cartArray[i].UPC == upcString{
                cartArray.removeAtIndex(i)
            }
        }
    }
    
    
    
    func changeQuantity(indexLocation: Int,newQuantity: Int){
        
        if newQuantity > 0 {
            cartArray[indexLocation].quantity = newQuantity
        }
            
        else {
            cartArray.removeAtIndex(indexLocation)
        }
        
        
        
    }
    
//    func updateAll(){
//        calculateSubtotal()
//        calculateSaleTax()
//        calculateTotal()
//        //ViewController.updateUI()
//        
//    }
    
    
    func packageForJSON(){
        
        
    }
    
    
    
}