//
//  SearchTableViewCell.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookReleaseDate: UILabel!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var isFavImage: UIImageView!
    @IBOutlet weak var bookArtistName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
