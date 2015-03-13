//
//  itemCell.swift
//  CartScanner
//
//  Created by Kenny Pham on 2/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}
