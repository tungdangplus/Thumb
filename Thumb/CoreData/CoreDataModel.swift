//
//  CoreDataModel.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import Foundation
import UIKit
import CoreData

class CoreDataModel {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveProductToCoreData(_ product: Product){
        getProductsFromCoreData { (arrProducts) in
            //check if 'product' has been saved before or not
            if arrProducts.contains(where: { (prod) -> Bool in prod.id == product.id }) {
                //stop saving 'product' to Core if it existed, just add quantity to Cart
            } else {
                //save 'product' to Core
                let contex = appDelegate.persistentContainer.viewContext
                if let entityName = NSEntityDescription.entity(forEntityName: "ProductEntity", in: contex), let productEntity = NSManagedObject(entity: entityName, insertInto: contex) as? ProductEntity {
                    
                    productEntity.id = product.id
                    productEntity.title = product.title
                    productEntity.detail = product.detail
                    productEntity.price = product.price ?? 0.00
                    productEntity.image = product.image?.pngData()
                    
                    appDelegate.saveContext()
                
                }
            }
        }
        
        //bonus (not related to handling CoreData)
        let currentQuantity: Int? = UserDefaults.standard.value(forKey: product.id!) as? Int
        UserDefaults.standard.setValue((currentQuantity ?? 0) + 1, forKey: product.id!)
        UserDefaults.standard.synchronize()
    }
    
    static func getProductsFromCoreData(completion:@escaping ([Product]) -> Void){
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        request.returnsObjectsAsFaults = false
        
        var products = [Product]()
        do {
            let dpGroup = DispatchGroup()
            
            let productEntities = try contex.fetch(request) as! [ProductEntity]
            for productEntity in productEntities {
                dpGroup.enter()
                var product = Product()
                product.id = productEntity.id
                product.title = productEntity.title
                product.detail = productEntity.detail
                product.price = productEntity.price
                if let imageData = productEntity.image {
                    product.image = UIImage(data: imageData)
                }
                
                products.append(product)
                dpGroup.leave()
            }
            
            dpGroup.notify(queue: .main) {
                completion(products)
            }
            
            
        }
        catch {
            print("fail to fetch request")
        }
        
    }
    
    static func deleteProductsFromCoreData(product: Product?, deleteAll: Bool){
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let productEntities = try contex.fetch(request) as! [ProductEntity]
            for productEntity in productEntities {
                if deleteAll == true {
                    contex.delete(productEntity)
                    appDelegate.saveContext()
                } else {
                    if product != nil, productEntity.id == product?.id {
                        contex.delete(productEntity)
                        appDelegate.saveContext()
                    }
                }
            }
            
        }
        catch {
            print("fail to fetch request")
        }
    }
    
}//class
