//
//  LikeListViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/19.
//

import UIKit


class LikeListViewController: UIViewController {

    @IBOutlet var likeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.likeListTableView.dataSource = self
        self.likeListTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 데이터 불러오기
        if let data = defaults.data(forKey: "ShoesLikeList") {
            shoesLikeList = try! PropertyListDecoder().decode([Shoes].self, from: data)
        }
        self.likeListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nikeDetailSegue" {
            let VC = segue.destination as! NikeDetailViewController
            VC.nikeShoes = sender as? Shoes
        }else {
            let VC = segue.destination as! NewbalanceDetailViewController
            VC.newbalanceShoes = sender as? Shoes
        }
    }
}

extension LikeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = try? PropertyListEncoder().encode(shoesLikeList) {
            defaults.set(data, forKey: "ShoesLikeList")
        }
        return shoesLikeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likeListTableView.dequeueReusableCell(withIdentifier: "likeListCell", for: indexPath) as! LikeListTableViewCell
        cell.likeShoesName.text = shoesLikeList[indexPath.row].name
        cell.likeShoesBrand.text = shoesLikeList[indexPath.row].brand
        cell.likeShoesImage.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: shoesLikeList[indexPath.row].img ?? "") else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }

            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.likeShoesImage.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                        cell.likeShoesImage.layer.cornerRadius = 25.0
                    }
                }
            }
        }
//        let url = URL(string: shoesLikeList[indexPath.row].img ?? "")
//        if let url = url, let data = try? Data(contentsOf: url) {
//            cell.likeShoesImage.image = UIImage(data: data)
//        }
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shoesLikeList[indexPath.row].brand == "nike" {
            performSegue(withIdentifier: "nikeDetailSegue", sender: shoesLikeList[indexPath.row])
        }else {
            performSegue(withIdentifier: "newbalanceDetailSegue", sender: shoesLikeList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var name:String
        if editingStyle == .delete {
            name = shoesLikeList[indexPath.row].name ?? ""
            shoesLikeList.remove(at: indexPath.row)
            likeListTableView.deleteRows(at: [indexPath], with: .fade)
            if let data = try? PropertyListEncoder().encode(shoesLikeList) {
                defaults.set(data, forKey: "ShoesLikeList")
            }
            var count:Int = 0
            for shoesGet in shoesGetDataList {
                if shoesGet.name == name {
                    shoesGetDataList[count].like = false
                }
                count += 1
            }
            var count2:Int = 0
            for nikeShoes in nikeCollectionViewList {
                if nikeShoes.name == name {
                    nikeCollectionViewList[count2].like = false
                }
                count2 += 1
            }
            var count3:Int = 0
            for newbalanceShoes in newbalanceCollectionViewList {
                if newbalanceShoes.name == name {
                    newbalanceCollectionViewList[count3].like = false
                }
                count3 += 1
            }
        }
    }
    
    
}
