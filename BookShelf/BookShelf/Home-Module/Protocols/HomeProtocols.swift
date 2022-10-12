//
//  HomeProtocols.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation


protocol ViewToPresenterHomeProtocol{
    var homeInteractor:PresenterToInteractorHomeProtocol?{get set}
    var homeView:PresenterToViewHomeProtocol?{get set}
    
    
    func getAllBooks()
    func addFav(selectedBook:BooksModel, isFavSelect:Bool)
    
}
protocol PresenterToInteractorHomeProtocol{
    var homePresenter: InteractorToPresenterHomeProtocol?{get set}
    
    func getBooks()
    func addFavourite(book:BooksModel, isFav:Bool)
}

protocol InteractorToPresenterHomeProtocol{
    func sendDataToPresenter(booksListesi:Array<BooksModel>)
    
}

protocol PresenterToViewHomeProtocol{
    func sendDataToView(booksListesi:Array<BooksModel>)
}

protocol PresenterToRouterHomeProtocol{
    static func createModule(ref:HomeVC)
}
