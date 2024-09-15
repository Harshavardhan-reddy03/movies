//
//  UIViewController+Extension.swift
//  assessment
//
//  Created by Harsha on 08/09/24.
//

import Foundation
import UIKit

extension UIViewController{
    // this method is used to load the JPEG image
    func loadJPEGImage(fileName: String, defaultImg:String = "movie", completion:@escaping((_ image:UIImage)->Void)){

        let fileURL = URL(string: fileName) ?? URL(fileURLWithPath: "")
        URLSession.shared.dataTask(with: fileURL){data,res,err in
            if let err {
                print("Error fetching image: \(err)")
                completion(UIImage(named: defaultImg) ?? UIImage())
                return
            }else if let res = res as? HTTPURLResponse{
                if (200...299).contains(res.statusCode){
                    guard let data = data else {
                        print("Invalid image data")
                        completion(UIImage(named: defaultImg) ?? UIImage())
                        return
                    }
                    completion((UIImage(data: data) ?? UIImage(named: defaultImg)) ?? UIImage())
                    return
                }else{
                    completion(UIImage(named: defaultImg) ?? UIImage())
                    return
                }
            }
        }.resume()
    }
}
