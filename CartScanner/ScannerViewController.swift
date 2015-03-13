//
//  ScannerViewController.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    let myButton: UIButton = UIButton()
    var boxView:UIView!;
    
    var scannedString: String?
    var scannedProduct = Product()
    
    var productDatabase = [Product(name: "Water Bottle", quantity: 1, UPC: "123456789", price: 2.49, imageReference: "water-bottle"), Product(name: "Camera", quantity: 1, UPC: "987654321", price: 199.99, imageReference: "camera")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        
        self.boxView = UIView(frame: self.view.frame);
        myButton.frame = CGRectMake(0,0,200,40)
        myButton.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        myButton.layer.masksToBounds = true
        myButton.setTitle("View Cart", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:500)
        myButton.addTarget(self, action: "viewCartPressed:", forControlEvents: .TouchUpInside)

        
        self.view.addSubview(self.boxView);
        self.view.addSubview(myButton)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        var detected = false
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as AVMetadataMachineReadableCodeObject).stringValue
                    detected = true
                    self.session.stopRunning()
                    break
                }
                
            }
        }
        
        println(detectionString)
        self.scannedString = detectionString
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        
        if detected == true{
            if checkItem(self.scannedString!, database: productDatabase) == true{
                self.scannedProduct = searchDatabase(self.scannedString!, database: productDatabase)
                self.performSegueWithIdentifier("scanned", sender: self)
            }
            
            if checkItem(self.scannedString!, database: productDatabase) == false{
                self.performSegueWithIdentifier("itemNotFound", sender: self)
            }
            
            
            
        
        //let viewController: AddToCartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddToCart") as AddToCartViewController
        //self.presentViewController(viewController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @IBAction func viewCartPressed(sender: UIButton) {
        self.performSegueWithIdentifier("viewTheCart", sender: self)
        
    }
    
    
    func checkItem(searchBarcode: String, database: Array<Product>) -> Bool{
        var foundItem = false
        
        for (var i=0; i<database.count; i++){
            if searchBarcode == database[i].UPC{
                foundItem = true
            }
        }
        
        return foundItem
        
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
        //var itemToAdd = segue.destinationViewController as AddToCartViewController
        
        //itemToAdd.scannerBarcode = self.scannedString!
        
        
        if segue.identifier == "scanned" {
            var itemToAdd = segue.destinationViewController as AddToCartViewController
            //itemToAdd.scannerBarcode = self.scannedString!
            itemToAdd.theProduct = self.scannedProduct
        }
        if segue.identifier == "itemNotFound" {
            var itemToAdd = segue.destinationViewController as ItemNotFoundViewController

        }
        
        
        if segue.identifier == "viewTheCart" {
            var itemToAdd = segue.destinationViewController as CartViewController
            itemToAdd.fromViewCartButton = true
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
