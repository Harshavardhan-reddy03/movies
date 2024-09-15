//
//  MovieTableViewCell.swift
//  assessment
//
//  Created by Harsha on 06/09/24.
//

import UIKit
protocol Favorite:AnyObject{
    func favorite(id: String)
}

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var isFavorite: UIButton!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    var movieId:String = ""
    var delegate:Favorite?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func favorite(_ sender: UIButton) {
        // calling the delegate method to change the favorite movie
        delegate?.favorite(id: movieId)
    }
}
