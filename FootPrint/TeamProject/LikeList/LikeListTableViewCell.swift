//
//  LikeListTableViewCell.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/24.
//

import UIKit

class LikeListTableViewCell: UITableViewCell {

    @IBOutlet var likeShoesImage: UIImageView!
    @IBOutlet var likeShoesName: UILabel!
    @IBOutlet var likeShoesBrand: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
