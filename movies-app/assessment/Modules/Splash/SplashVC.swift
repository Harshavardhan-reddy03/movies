//
//  SplashVC.swift
//  assessment
//
//  Created by Harsha on 05/09/24.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigating to the movie list screen after displaying the splash screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.navigationBar.isHidden = true
            let storyboard = UIStoryboard(name: "MovieList", bundle: nil)
            if let scene = storyboard.instantiateViewController(withIdentifier: "MovieListVC") as? MovieListVC{
                self.navigationController?.pushViewController(scene, animated: true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
