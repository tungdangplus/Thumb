//
//  CartCell.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import UIKit

class CartCell: UITableViewCell {
    @IBOutlet weak var imvThumnail: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblPriceTag: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    var cartVC: CartVC?
    var product: Product?
    
    
    @IBOutlet weak var btnSubtract: UIButton!
    @IBAction func btnSUBTRACT(_ sender: Any) {
        guard product != nil else {
            return
        }
        
        currentQuantity -= 1
        if currentQuantity < 1 {
            currentQuantity = 1
        }
        lblQuantity.text = String(currentQuantity)
    
        //Save
        UserDefaults.standard.removeObject(forKey: product!.id!)
        UserDefaults.standard.setValue(currentQuantity, forKey: product!.id!)
        UserDefaults.standard.synchronize()
        
//        cartVC?.fetchProducts()
    }
    
    var currentQuantity: Int = 1
    
    @IBOutlet weak var btnAddMore: UIButton!
    @IBAction func btnADDMORE(_ sender: Any) {
        guard product != nil else {
            return
        }
        currentQuantity += 1
        lblQuantity.text = String(currentQuantity)
        
        //Save
        UserDefaults.standard.removeObject(forKey: product!.id!)
        UserDefaults.standard.setValue(currentQuantity, forKey: product!.id!)
        UserDefaults.standard.synchronize()
        
//        cartVC?.fetchProducts()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.isHighlighted = false
        // Configure the view for the selected state
    }

}
