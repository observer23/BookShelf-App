//
//  SearchProtocols.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation
protocol ViewToPresenterSearchProtocol{
    var searchInteractor:PresenterToInteractorSearchProtocol?{get set}
    var searchView:PresenterToViewSearchProtocol?{get set}
    
    
    func getAllBooks()
    func changeFav(selectedBook:BooksModel, isFavSelect:Bool)
    func searchBooks(aramaKelimesi:String)
    
}
protocol PresenterToInteractorSearchProtocol{
    var searchPresenter: InteractorToPresenterSearchProtocol?{get set}
    
    func getBooks()
    func changeFavourite(book:BooksModel, isFav:Bool)
    func findBooks(aramaKelime: String)
}

protocol InteractorToPresenterSearchProtocol{
    func sendDataToPresenter(booksListesi:Array<BooksModel>)
    
}

protocol PresenterToViewSearchProtocol{
    func sendDataToView(booksListesi:Array<BooksModel>)
}

protocol PresenterToRouterSearchProtocol{
    static func createModule(ref:SearchVC)
}
