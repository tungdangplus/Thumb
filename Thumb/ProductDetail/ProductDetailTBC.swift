//
//  ProductDetailController.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import UIKit

class ProductDetailTBC: UITableViewController {
    @IBOutlet weak var imvProductImage: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var tvProductDetail: UITextView!
    @IBOutlet weak var lblPriceTag: UILabel!
    
    @IBAction func btnADDTOCART(_ sender: Any) {
        if let product = product {
            CoreDataModel.saveProductToCoreData(product)
            ExtraModel.quickMessageAlert("Added", presentingVC: self)
        }
    }
    
    var product: Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        imvProductImage.image = product?.image
        lblProductTitle.text = product?.title
        tvProductDetail.text = product?.detail
        lblPriceTag.text = String(product?.price ?? 0.00) + " $"
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let presentingVC = self.presentingViewController {
            presentingVC.viewWillAppear(true)
            presentingVC.viewDidAppear(true)
        }
    }

    // MARK: - Table view data source


}
