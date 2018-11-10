//
//  Extensions.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    subscript (i: Int) -> String {
        let elIndex = index(startIndex, offsetBy: i)
        return String(self[elIndex])
    }
    subscript (r: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound + 1)
        return String(self[start..<end])
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//extension UIImageView {
//    func imageFromServerURL(urlString: String) {
//        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                DispatchQueue.main.async(execute: { () -> Void in
//                    print("The image was downloaded, but could not be rendered.")
//                })
//                return
//            }
//            DispatchQueue.main.async(execute: { () -> Void in
//                if data != nil {
//                    if let image = UIImage(data: data!) {
//                        self.image = image
//                    }
//                }else{
//                    return
//                }
//            })
//        }).resume()
//    }
//}
