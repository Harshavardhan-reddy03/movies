//
//  MovieListVC.swift
//  assessment
//
//  Created by Harsha on 05/09/24.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var searchMovie: UISearchBar!
    @IBOutlet weak var movieListTable: UITableView!
    var movieList : MovieListModel? = nil
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        searchMovie.delegate = self
        
        //configuring the movie list table
        setUpTable()
        //getting the movies list with default
        loadPagination(searchString: "ave")
        
        // hiding the keyboard on click on the screen
        let endEditingTapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        endEditingTapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endEditingTapGesture)
    }
    // this method is used to setup the table
    func setUpTable(){
        movieListTable.dataSource = self
        movieListTable.delegate = self
        movieListTable.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        movieListTable.register(UINib(nibName: "LoaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LoaderTableViewCell")
    }
    // This method is to call the api to get the movies list
    func loadPagination(searchString: String){
        page = page + 1
        
        let payload = [
            "apikey" : APIEndPoints().apiKey,
            "s" : searchString.count < 3 ? "ave" : searchString.trimmingCharacters(in: CharacterSet(charactersIn: " ")),
            "page" : page
        ] as [String : Any]
        APIManager.shared.performGetRequest(endPointName: "", queryParams: payload, resultType: MovieListModel.self, completion: {result,error in
            if let result{
                DispatchQueue.main.async {
                    self.page == 1 ? self.movieList = result : self.movieList?.Search.append(contentsOf: result.Search)
                    print("result count",self.movieList?.Search.count)
                    self.movieListTable.reloadData()
                }
            }
        })
    }
}
extension MovieListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (movieList?.Search.count ?? 0 < (Int(movieList?.totalResults ?? "") ?? 0)){
            return (movieList?.Search.count ?? 0) + 1
        }
        return movieList?.Search.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row num",indexPath.row)
        if (movieList?.Search.count ?? 0 < (Int(movieList?.totalResults ?? "") ?? 0)) && (((movieList?.Search.count ?? 1)) == indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderTableViewCell", for: indexPath) as? LoaderTableViewCell else { return UITableViewCell() }
            cell.isUserInteractionEnabled = false
            cell.activityIndicator.startAnimating()
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath ) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        if movieList?.Search != nil{
            cell.movieTitle.text = movieList?.Search[indexPath.row].title
            cell.releaseYear.text = movieList?.Search[indexPath.row].releaseYear
            cell.movieId = movieList?.Search[indexPath.row].id ?? ""
            let isFav = isFavoriteMovie(id: movieList?.Search[indexPath.row].id ?? "")
            cell.isFavorite.setImage(UIImage(systemName: isFav ? "star.fill" : "star"), for: .normal)
            DispatchQueue.main.async {
                if  self.movieList?.Search[indexPath.item].posterImage != nil {
                    self.loadJPEGImage(fileName: self.movieList?.Search[indexPath.item].posterImage ?? "", completion: {image in
                        DispatchQueue.main.async {
                            cell.posterImg.image = image
                            cell.posterImg.contentMode = .scaleAspectFit
                        }
                    })
                } else{
                    cell.posterImg.image = UIImage(named: "movie")
                }
            }
            cell.delegate = self
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        cell.backgroundColor = .clear
        let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
        if let scene = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsVC{
            scene.movieName = cell.movieTitle.text ?? "Movie"
            scene.movieId = cell.movieId
            navigationController?.pushViewController(scene, animated: true)
        }
        print("cell selected")
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    //this delegate is used to call the pagination
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadPagination(searchString: searchMovie.text ?? "ave")
    }
    
}
extension MovieListVC: UISearchBarDelegate{
    //this delegate method is used to search the movies list by the entered search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 0
        loadPagination(searchString: searchText)
    }
}
extension MovieListVC: Favorite{
    // this delegate method is used to track the favorite movie
    func favorite(id: String) {
        if let data = UserDefaults.standard.data(forKey: "FavoriteMovie") {
            if var movieIds = try? JSONDecoder().decode([String].self, from: data){
                if movieIds.contains(id){
                    movieIds.removeAll(where: {$0 == id})
                }
                else{
                    movieIds.append( id)
                    
                }
                let eData = try? JSONEncoder().encode(movieIds)
                UserDefaults.standard.setValue(eData, forKey: "FavoriteMovie")
            }
        }else{
            let eData = try? JSONEncoder().encode([id])
            UserDefaults.standard.setValue(eData, forKey: "FavoriteMovie")
        }
        movieListTable.reloadData()
    }
    //this method is used to check the favorite movie
    func isFavoriteMovie(id:String)->Bool{
        if let data = UserDefaults.standard.data(forKey: "FavoriteMovie") {
            if let movieIds = try? JSONDecoder().decode([String].self, from: data){
                if movieIds.contains(id){
                    return true
                }
                else{
                    return false
                    
                }
            }
        }
        return false
    }
    
}
