//
//  SearchVC.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import UIKit

class SearchVC: UIViewController{
    let context = app.persistentContainer.viewContext
    @IBOutlet weak var SearchTableView: UITableView!
    var booksList = [BooksModel]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchPresenterObject : ViewToPresenterSearchProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTableView.delegate = self
        SearchTableView.dataSource = self

        SearchRouter.createModule(ref: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        searchPresenterObject?.getAllBooks()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetaile"{
            if let book = sender as? BooksModel{
                let destinationVC = segue.destination as! DetailVC
                destinationVC.sendBook = book
            }
        }
    }

    

}
extension SearchVC:PresenterToViewSearchProtocol{
    func sendDataToView(booksListesi: Array<BooksModel>) {
        self.booksList = booksListesi
        self.SearchTableView.reloadData()
    }
    
    
}
extension SearchVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            searchPresenterObject?.getAllBooks()
        }else{
            searchPresenterObject?.searchBooks(aramaKelimesi:searchText)
        }
       
    }
    
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = booksList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        cell.bookName.text = book.name!
        cell.bookArtistName.text = book.artistName!
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM ,yyyy"
        if let date = dateFormatterGet.date(from: (book.releaseDate!)) {
            let tarih = dateFormatterPrint.string(from: date)
            cell.bookReleaseDate.text = tarih
        } else {
            print("Wrong!")
        }
        cell.bookImage.loadFrom(URLAddress: book.artworkUrl100!)
        
        if book.favourite == true {
            cell.isFavImage.image = UIImage(systemName: "star.fill")
            cell.isFavImage.tintColor = .yellow
        }else{
            cell.isFavImage.image = UIImage(systemName: "star")
            cell.isFavImage.tintColor = .gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = booksList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toDetaile", sender: book)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ (contextualAction,view,bool) in
            let book  = self.booksList[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(book.name!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel){action in}
            let evetAction = UIAlertAction(title: "Evet", style: .destructive){action in
                self.context.delete(book)
                app.saveContext()            }
            
                
            
            alert.addAction(iptalAction)
            alert.addAction(evetAction)
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    
    
}
}
