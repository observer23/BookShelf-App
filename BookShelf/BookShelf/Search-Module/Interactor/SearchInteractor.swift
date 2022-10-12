//
//  SearchInteractor.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation

class SearchInteractor:PresenterToInteractorSearchProtocol{
    let context = app.persistentContainer.viewContext
    var searchPresenter: InteractorToPresenterSearchProtocol?
    
    func getBooks() {
        do{
            let liste = try context.fetch(BooksModel.fetchRequest())
            searchPresenter?.sendDataToPresenter(booksListesi: liste)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func changeFavourite(book: BooksModel, isFav: Bool) {
        book.favourite = isFav
        app.saveContext()
    }
    
    func findBooks(aramaKelime: String){
        do{
            let fr = BooksModel.fetchRequest()
            fr.predicate = NSPredicate(format: "name CONTAINS %@", aramaKelime)
            
            let liste = try context.fetch(fr)
            searchPresenter?.sendDataToPresenter(booksListesi: liste)
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
