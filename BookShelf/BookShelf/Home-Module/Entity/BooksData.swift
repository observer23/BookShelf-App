//
//  BooksModel.swift
//  BookShelf
//
//  Created by Ekin Atasoy on 11.10.2022.
//

import Foundation


struct AllData:Decodable{
    var feed:BooksData
    
}
struct BooksData:Decodable{
    var results:[BookData]
}
struct BookData:Decodable{
    let artistName:String
    let name:String
    let releaseDate:String
    let artistUrl:String?
    let artworkUrl100:String
}
