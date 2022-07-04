//
//  PopUpVC.swift
//  ARSneakers
//
//  Created by Ahmad Qureshi on 20/05/22.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var titleToShow = String()
    var messageToShow = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    func setUpData() {
        if titleToShow != "" && messageToShow != "" {
            titleLabel.text = titleToShow
            messageLabel.text = messageToShow
        }
    }
    @IBAction func okBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
