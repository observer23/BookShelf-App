//
//  HomePresenter.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation


class HomePresenter:ViewToPresenterHomeProtocol{
    var homeInteractor: PresenterToInteractorHomeProtocol?
    
    var homeView: PresenterToViewHomeProtocol?
    
    func getAllBooks() {
        homeInteractor?.getBooks()
    }
    
    func addFav(selectedBook: BooksModel, isFavSelect: Bool) {
        homeInteractor?.addFavourite(book: selectedBook, isFav: isFavSelect)
    }
    
    
}

extension HomePresenter:InteractorToPresenterHomeProtocol{
    func sendDataToPresenter(booksListesi: Array<BooksModel>) {
        homeView?.sendDataToView(booksListesi: booksListesi)
    }
    
    
}
