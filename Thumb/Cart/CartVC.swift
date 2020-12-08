//
//  CartVC.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import UIKit

class CartVC: UIViewController {
    
    var arrProducts = [Product]()
    var totalItem: Int?
    var totalCost: Double?
    
//
    @IBAction func btnREMOVEALL(_ sender: Any) {
        for product in arrProducts {
            UserDefaults.standard.removeObject(forKey: product.id!)
        }
        
        arrProducts.removeAll()
        CoreDataModel.deleteProductsFromCoreData(product: nil, deleteAll: true)
        tbvCart.reloadData()
        
        self.tabBarItem.badgeValue = nil
        
    }
    
    
    @IBOutlet weak var lblTotalItems: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    @IBOutlet weak var btnCheckOut: UIButton! {
        didSet {
            btnCheckOut.layer.borderWidth = 1
            btnCheckOut.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBAction func btnCHECKOUT(_ sender: Any) {
        print("CHECK OUT")
    }
    
//StoryBoard Properties
    @IBOutlet weak var tbvCart: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProducts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //
    }
    
    @objc func fetchProducts(){
        self.totalItem = 0
        self.totalCost = 0
        CoreDataModel.getProductsFromCoreData { (arrOfProducts) in
            self.arrProducts = arrOfProducts
            
            for product in arrOfProducts {
                var quantity: Int = 0
                if UserDefaults.standard.value(forKey: product.id!) != nil {
                    quantity = UserDefaults.standard.value(forKey: product.id!) as! Int
                }
                
                let cost = Double(quantity) * (product.price ?? 0.00)
                self.totalItem! += quantity
                self.totalCost! += cost
            }
            
            self.lblTotalItems.text = String(self.totalItem ?? 0)
            
            let roundedNumber = Double(round(100 * (self.totalCost ?? 0.00))/100)
            self.lblTotalCost.text = String(roundedNumber) + " $"
            
            self.updateCartBadge()
            
            //
            self.tbvCart.reloadData()
        }
    }
    
    public func updateCartBadge(){
        var itemCount: Int = 0
        CoreDataModel.getProductsFromCoreData { (arrProduct) in
            for product in arrProduct {
                if let count = UserDefaults.standard.value(forKey: product.id!) as? Int {
                    itemCount += count
                }
            }
            
            if itemCount > 0 {
                self.tabBarItem.badgeValue = String(itemCount)
            } else {
                self.tabBarItem.badgeValue = nil
            }
        }
        
    }
}


extension CartVC: UITableViewDelegate, UITableViewDataSource {
    //Handle Layout
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width/4
    }
    
    //Handle Data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvCart.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell else {
            return UITableViewCell()
        }
        
        let product = arrProducts[indexPath.row]
        cell.product = product
        
        cell.imvThumnail.image = product.image
        cell.lblProductTitle.text = product.title
        cell.lblPriceTag.text = String(product.price ?? 0.00) + " $"
        
        var quantity: Int = 0
        if UserDefaults.standard.value(forKey: product.id!) != nil {
            quantity = UserDefaults.standard.value(forKey: product.id!) as! Int
        }
        
        cell.currentQuantity = quantity
        cell.lblQuantity.text = String(quantity)
        
        cell.btnSubtract.addTarget(self, action: #selector(fetchProducts), for: .touchUpInside)
        cell.btnAddMore.addTarget(self, action: #selector(fetchProducts), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = arrProducts[indexPath.item]
        if let productDetailTBC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailTBC") as? ProductDetailTBC {
            productDetailTBC.product = product
            present(productDetailTBC, animated: true, completion: nil)
        }
    }
    
    //Edit mode
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let remove = UIContextualAction(style: .destructive, title: "Remove") { (action, actionView, boolOption) in
            let product = self.arrProducts[indexPath.item]
            self.arrProducts.removeAll { (productToRemove) -> Bool in
                productToRemove.id == product.id
            }
//            self.tbvCart.reloadData()
            
            //
            UserDefaults.standard.removeObject(forKey: product.id!)
            CoreDataModel.deleteProductsFromCoreData(product: product, deleteAll: false)
            
            self.fetchProducts()
        }
        
        return UISwipeActionsConfiguration(actions: [remove])
    }
    
    
}
