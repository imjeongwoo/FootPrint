//
//  ArticlesTableViewCell.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/25.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
