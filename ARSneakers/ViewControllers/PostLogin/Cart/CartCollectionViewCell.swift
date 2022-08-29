//
//  CartCollectionViewCell.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 20/05/22.
//

import UIKit

var removeCartItem : (() -> Void)?
class CartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var viewWhenNoItem: UIView!
    var productIndex = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func sizeBtnPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @IBAction func removeFromCart(_ sender: UIButton) {
        for (index,item) in DataBase.shared.allData.enumerated() {
            if item.uuid == DataBase.shared.cartData[productIndex].uuid {
                DataBase.shared.allData[index].addedToCart = false
                break
            }
        }
        removeCartItem?()
    }
}
