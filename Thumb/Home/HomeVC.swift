//
//  HomeVC.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import UIKit

class HomeVC: UIViewController {
    let margin: CGFloat = 8
    var arrProducts = [Product]()
    
//Storyboard Properties
    @IBOutlet weak var imvLogo: UIImageView! {
        didSet {
            imvLogo.layer.cornerRadius = imvLogo.frame.width/2
        }
    }
    
    @IBAction func btnCONTACT(_ sender: Any) {
        print("Handle to make a call")
    }
    
    @IBOutlet weak var cvHome: UICollectionView!
    
// override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView item space
        if let layout = cvHome.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = margin * 2
            layout.minimumInteritemSpacing = margin * 2
        }
        
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCartBadge()
    }
    
    @objc func updateCartBadge(){
        if let cartVC = self.tabBarController?.viewControllers?[1] as? CartVC {
            cartVC.updateCartBadge()
        }
    }
    
    private func fetchProducts(){
        let productImages: [UIImage] = [UIImage(named: "clothing_001")!, UIImage(named: "clothing_002")!, UIImage(named: "clothing_003")!, UIImage(named: "clothing_004")!, UIImage(named: "clothing_005")!, UIImage(named: "clothing_006")!, UIImage(named: "clothing_007")!, UIImage(named: "clothing_008")!]
        
        var idCode = 0
        for image in productImages {
            idCode += 1
            var product = Product()
            product.id = "productcode_\(idCode)"
            let compressImage = image.jpegData(compressionQuality: 0.5)
            product.image = UIImage(data: compressImage!)
            product.title = "Clothing_\(idCode)"
            product.detail = "All details about product " + product.title!
            product.price = 24.99
            
            arrProducts.append(product)
        }
        
    }
    
    private func loadProductsFromServer(){
        let products = [Product]()
        
        
        //after handling products from server
        arrProducts.append(contentsOf: products)
    }

}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //Handle Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: margin, left: margin * 2, bottom: margin, right: margin * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (collectionView.frame.width - margin * 4 - flowLayout.minimumInteritemSpacing)/2
        let cellHeight = cellWidth * 2
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //Handle Data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cvHome.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else {
            return UICollectionViewCell()
        }
        cell.homeVC = self
        
        let product = arrProducts[indexPath.item]
        cell.productForAdding = product
        
        cell.imvThumnail.image = product.image
        cell.lblProductTitle.text = product.title
        cell.lblPriceTag.text = String(product.price ?? 0.0) + " $"
        
        cell.btnAddToCart.addTarget(self, action: #selector(self.updateCartBadge), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = arrProducts[indexPath.item]
        if let productDetailTBC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailTBC") as? ProductDetailTBC {
            productDetailTBC.product = product
            present(productDetailTBC, animated: true, completion: nil)
        }
    }
    
}
