//
//  HomeInteractor.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation

class HomeInteractor:PresenterToInteractorHomeProtocol{
    let context = app.persistentContainer.viewContext
    var homePresenter: InteractorToPresenterHomeProtocol?
    
    func addFavourite(book:BooksModel, isFav:Bool) {
        book.favourite = isFav
        app.saveContext()
    }
    func getBooks() {
        do{
            let liste = try context.fetch(BooksModel.fetchRequest())
            homePresenter?.sendDataToPresenter(booksListesi: liste)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    
    
}
