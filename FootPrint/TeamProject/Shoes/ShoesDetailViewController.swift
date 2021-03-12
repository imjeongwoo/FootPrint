//
//  ShoesDetailViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/21.
//

import UIKit

class ShoesDetailViewController: UIViewController {

    @IBOutlet var shoesDetailImage: UIImageView!
    @IBOutlet var shoesDetailBrand: UILabel!
    @IBOutlet var shoesDetailName: UILabel!
    @IBOutlet var shoesDetailPrice: UILabel!
    
    
    var shoesDetail: Nike? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: shoesDetail?.img ?? "")
        if let url = url, let data = try? Data(contentsOf: url) {
            shoesDetailImage.image = UIImage(data: data)
        }
        shoesDetailBrand.text = shoesDetail?.brand
        shoesDetailName.text = shoesDetail?.name
        shoesDetailPrice.text = "\(shoesDetail!.originPrice ?? 0) 원"

        // Do any additional setup after loading the view.
    }
    



}
