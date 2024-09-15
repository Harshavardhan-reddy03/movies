//
//  MovieDetailsVC.swift
//  assessment
//
//  Created by Harsha on 09/09/24.
//

import UIKit

class MovieDetailsVC: UIViewController {


    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var ratingsTable: UITableView!
    
    var movieName:String = ""
    var movieId:String = ""
    var movieDetails: MovieDetailsModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI(){
        movieTitle.text = movieName
        ratingsTable.delegate = self
        ratingsTable.dataSource = self
        ratingsTable.register(UINib(nibName: "RatingsTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingsTableViewCell")
        let payload = [
            "apikey" : APIEndPoints().apiKey,
            "i" : movieId,
        ]
        APIManager.shared.performGetRequest(endPointName: "", queryParams: payload, resultType: MovieDetailsModel.self){result,error in
            DispatchQueue.main.async {
                if let result{
                    self.movieDetails = result
                    self.movieDesc.text = result.description
                    self.movieGenre.text = result.genre
                    self.ratingsTable.reloadData()
                    print("ratings",result)
                }
            }
        }
    }

    @IBAction func backNav(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        sender.isEnabled = false
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
extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetails?.ratings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingsTableViewCell",for: indexPath) as? RatingsTableViewCell else {
            return UITableViewCell()
        }
        cell.rating.text = "\(movieDetails?.ratings[indexPath.row].source ?? "") - \(movieDetails?.ratings[indexPath.row].value ?? "")"
        return cell
    }
    
    
}
