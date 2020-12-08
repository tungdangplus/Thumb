//
//  HomeCell.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var imvThumnail: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblPriceTag: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    var productForAdding: Product?
    var homeVC: HomeVC?
    @IBAction func btnADDTOCART(_ sender: Any) {
        if let product = productForAdding {
            CoreDataModel.saveProductToCoreData(product)
            ExtraModel.quickMessageAlert("Added", presentingVC: homeVC!)
        }
    }
}
