//
//  DataBaseModel.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 19/05/22.
//

import Foundation
struct DataBaseModel {
    var resourceName : String
    var companyName : String
    var productModel : String
    var productDescription : String
    var productPrice : String
    var isFavourite : Bool = false
    var addedToCart : Bool = false
    let uuid = UUID().uuidString
}
