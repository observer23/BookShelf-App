//
//  SearchRouter.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation
class SearchRouter:PresenterToRouterSearchProtocol{
    static func createModule(ref: SearchVC) {
        let presenter = SearchPresenter()
        // View
        ref.searchPresenterObject = presenter
        // Presenter
        ref.searchPresenterObject?.searchView = ref
        ref.searchPresenterObject?.searchInteractor = SearchInteractor()
        
        // Interactor
        
        ref.searchPresenterObject?.searchInteractor?.searchPresenter = presenter
    }
    
    
}
