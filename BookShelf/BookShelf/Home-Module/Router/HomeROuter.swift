//
//  HomeRouter.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation

class HomeRouter:PresenterToRouterHomeProtocol{
    static func createModule(ref: HomeVC) {
        let presenter = HomePresenter()
        // View
        ref.homePresenterObject = presenter
        // Presenter
        ref.homePresenterObject?.homeView = ref
        ref.homePresenterObject?.homeInteractor = HomeInteractor()
        
        // Interactor
        
        ref.homePresenterObject?.homeInteractor?.homePresenter = presenter
    }
    
    
}
