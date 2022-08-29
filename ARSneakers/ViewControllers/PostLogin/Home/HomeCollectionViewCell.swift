//
//  HomeCollectionViewCell.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 18/05/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    var productIndex = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBAction func favButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        DataBase.shared.allData[productIndex].isFavourite.toggle()
    }
    
}
