//
//  SearchPresenter.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation

class SearchPresenter:ViewToPresenterSearchProtocol{
    var searchInteractor: PresenterToInteractorSearchProtocol?
    
    var searchView: PresenterToViewSearchProtocol?
    
    func getAllBooks() {
        searchInteractor?.getBooks()
    }
    
    func changeFav(selectedBook: BooksModel, isFavSelect: Bool) {
        searchInteractor?.changeFavourite(book: selectedBook, isFav: isFavSelect)
    }
    func searchBooks(aramaKelimesi:String){
        searchInteractor?.findBooks(aramaKelime: aramaKelimesi)
    }
    
}

extension SearchPresenter:InteractorToPresenterSearchProtocol{
    func sendDataToPresenter(booksListesi: Array<BooksModel>) {
        searchView?.sendDataToView(booksListesi: booksListesi)
    }
    
    
}
