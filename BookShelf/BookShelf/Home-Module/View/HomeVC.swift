//
//  ViewController.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import UIKit

class HomeVC: UIViewController {
    let context = app.persistentContainer.viewContext
    
    var booksList = [BooksModel]()
    var newList = [BooksModel]()
    @IBOutlet weak var BooksCollectionView: UICollectionView!
    
    var homePresenterObject : ViewToPresenterHomeProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do{
            let list = try context.fetch(BooksModel.fetchRequest())
            if list.isEmpty{
                takeBooks()
                homePresenterObject?.getAllBooks()
            }else{
                print("DB zaten var. \(list.count)")
                homePresenterObject?.getAllBooks()
            }
        }catch{
            print(String(describing: error))
        }
        makeDesign()
        tabBarAppereance()
        BooksCollectionView.dataSource = self
        BooksCollectionView.delegate = self
        
        HomeRouter.createModule(ref: self)
        
    }
    @IBAction func barButtonFilter(_ sender: Any) {
        barButtonFunction()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if newList.isEmpty == true{
            homePresenterObject?.getAllBooks()
            self.BooksCollectionView.reloadData()
        }else{
            self.booksList = self.newList
            self.BooksCollectionView.reloadData()
        }
    }
    
    
    
    
}
extension HomeVC:PresenterToViewHomeProtocol{
    func sendDataToView(booksListesi: Array<BooksModel>) {
        self.booksList = booksListesi
        DispatchQueue.main.async {
            self.BooksCollectionView.reloadData()
        }
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksList.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = booksList[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: book)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let book = booksList[indexPath.row]
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCollectionViewCell
        
        cell.layer.borderWidth = 1
        
        cell.bookNameLabel.text = book.name
        if book.favourite == true {
            cell.isFavImage.image = UIImage(systemName: "star.fill")
            cell.isFavImage.layer.cornerRadius = 25
            cell.isFavImage.tintColor = .yellow
        }else{
            cell.isFavImage.image = UIImage(systemName: "star")
            cell.isFavImage.layer.cornerRadius = 25
            cell.isFavImage.tintColor = .gray
        }
        
        cell.bookImageView.loadFrom(URLAddress: book.artworkUrl100!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            if let book = sender as? BooksModel{
                let destinationVC = segue.destination as! DetailVC
                destinationVC.sendBook = book
            }
        }
    }
    
    
}
extension HomeVC{
    func takeBooks(){
        let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/books/top-free/100/books.json")
        URLSession.shared.dataTask(with: url!){data,response,error in
            if error != nil || data == nil {
                print("Hata")
                return
            }
            do{
                let safeData = try JSONSerialization.jsonObject(with: data!,options:[])
                print(safeData)
                self.parseJSON(safeData:data!)
            }catch{
                print("Json Error : \(error.localizedDescription)")
            }
        }
        .resume()
    }
    func parseJSON(safeData:Data){
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(AllData.self, from: safeData)
            for i in 0...19{
                let newBook=BooksModel(context: context)
                newBook.name = decodedData.feed.results[i].name
                newBook.artistName = decodedData.feed.results[i].artistName
                newBook.artistUrl = decodedData.feed.results[i].artistUrl
                newBook.releaseDate = decodedData.feed.results[i].releaseDate
                newBook.artworkUrl100 = decodedData.feed.results[i].artworkUrl100
                newBook.favourite = false
                app.saveContext()
            }
            
        }catch{
            print("Bu: \(String(describing: error))")
        }
    }
}

extension HomeVC{
    func makeDesign(){
        let tasarim=UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left:  10, bottom: 10, right: 10)
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        let genislik = BooksCollectionView.frame.size.width
        let itemGenislik = (genislik-30)/2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik*1.5)
        
        BooksCollectionView.collectionViewLayout = tasarim
    }
    func barButtonFunction(){
        let alert = UIAlertController(title: "Filter By", message: "Please Choose", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All", style: .default , handler:{ (UIAlertAction)in
            self.homePresenterObject?.getAllBooks()
            self.navigationItem.title = "All Books"
            
        }))
        
        alert.addAction(UIAlertAction(title: "New To Old", style: .default , handler:{ (UIAlertAction)in
            self.homePresenterObject?.getAllBooks()
            self.newList = self.booksList.sorted(by: { $0.releaseDate! > $1.releaseDate! })
            self.booksList = self.newList
            self.navigationItem.title = "New to Old"
        }))
        
        alert.addAction(UIAlertAction(title: "Old To New", style: .default , handler:{ (UIAlertAction)in
            self.homePresenterObject?.getAllBooks()
            self.newList = self.booksList.sorted(by: { $0.releaseDate! < $1.releaseDate! })
            self.booksList = self.newList
            self.navigationItem.title = "Old To New"
        }))
        
        alert.addAction(UIAlertAction(title: "Favourites", style: .default, handler:{ (UIAlertAction)in
            self.navigationItem.title = "Favourites"
            self.homePresenterObject?.getAllBooks()
            self.newList.removeAll()
            for i in 0...19{
                if self.booksList[i].favourite == true {
                    self.newList.append(self.booksList[i])
                }
            }
            self.booksList = self.newList
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

extension HomeVC{
    func tabBarAppereance(){
        let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(named: "general")
                
                renkDegistir(itemApperance: appearance.stackedLayoutAppearance)
                renkDegistir(itemApperance: appearance.inlineLayoutAppearance)
                renkDegistir(itemApperance: appearance.compactInlineLayoutAppearance)
                
                tabBarController?.tabBar.standardAppearance = appearance
                tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }
    func renkDegistir(itemApperance:UITabBarItemAppearance){
            itemApperance.selected.iconColor = UIColor.black
            itemApperance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
            itemApperance.selected.badgeBackgroundColor = UIColor.red
            
            itemApperance.normal.iconColor = UIColor.darkGray
            itemApperance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
            itemApperance.normal.badgeBackgroundColor = UIColor.red
            
        }
}
