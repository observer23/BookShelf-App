//
//  DetailVC.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import UIKit
import SafariServices
class DetailVC: UIViewController {

    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookArtistNAme: UILabel!
    @IBOutlet weak var releaseDateLAbel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var favButtonImage: UIBarButtonItem!
    var sendBook: BooksModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bookNameLabel.text = sendBook?.name!
        bookArtistNAme.text = sendBook?.artistName!
        bookImage.layer.borderWidth = 1
        bookImage.layer.cornerRadius = 25
        bookImage.layer.borderColor = UIColor(named: "cellBorderColor")?.cgColor
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM ,yyyy"
        if let date = dateFormatterGet.date(from: (sendBook?.releaseDate!)!) {
            let tarih = dateFormatterPrint.string(from: date)
            releaseDateLAbel.text = tarih
        } else {
            print("Wrong!")
        }
        
        bookImage.loadFrom(URLAddress: (sendBook?.artworkUrl100!)!)
        if sendBook?.favourite == true {
            favButtonImage.image = UIImage(systemName: "star.fill")
            favButtonImage.tintColor = .yellow
        }else{
            favButtonImage.image = UIImage(systemName: "star")
            favButtonImage.tintColor = .gray
        }
        
        
    }
    
    @IBAction func favButtonItem(_ sender: Any) {
        if sendBook?.favourite == true {
            sendBook?.favourite = false
            favButtonImage.image = UIImage(systemName: "star")
            favButtonImage.tintColor = .gray
        }else{
            sendBook?.favourite = true
            favButtonImage.image = UIImage(systemName: "star.fill")
            favButtonImage.tintColor = .yellow
        }
        
        
    }
    
    @IBAction func morInfoButton(_ sender: Any) {
        if let url = NSURL(string: (sendBook?.artistUrl!)!){
                    let dest = SFSafariViewController(url: url as URL)
                    present(dest, animated: true, completion: nil)
                }
    }
    
}
