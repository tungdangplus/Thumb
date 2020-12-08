//
//  ExtraModel.swift
//  Thumb
//
//  Created by TungDang on 07/12/2020.
//

import Foundation
import UIKit

class ExtraModel {
    static func quickMessageAlert(_ message: String, presentingVC: UIViewController){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.view.alpha = 0.5
        
        presentingVC.present(alert, animated: true) {
            //set small Vibrating
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            //Dismis alert
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }//quickAlertMessage()
}
