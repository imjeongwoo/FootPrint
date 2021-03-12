//
//  HomeViewController.swift
//  TeamProject
//
//  Created by 임정우 on 2021/01/14.
//

import UIKit
import Firebase
import SafariServices

let defaults = UserDefaults.standard

class ArticlesViewController: ExtensionVC{
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var articlesList = [Articles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        initRefresh()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        DispatchQueue.global().async {
            self.updateArticles()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIViewController.removeSpinner(spinner: sv)
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        NewsAPI.shared.getNews(completion: { news in
//            self.news = news
//            self.tableView.reloadData()
//        })
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        updateArticles()
    }
    
    func viewOnSafari(url: String) {
        let siteURL = url
        guard let url = URL(string: siteURL) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(safariViewController, animated: true, completion: nil)
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return articlesList.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 10 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesTableViewCell", for: indexPath) as! ArticlesTableViewCell
            let article:Articles
            article = articlesList[indexPath.row]
            
            cell.newsTitle.text = article.title
            cell.newsDate.text = article.time
            cell.newsImageView?.image = nil
            
            DispatchQueue.global().async {
                guard let imageURL: URL = URL(string: article.img ?? "") else { return }
                guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
    
                DispatchQueue.main.async {
                    if let index: IndexPath = tableView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            cell.newsImageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                            cell.layoutIfNeeded()
                        }
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTotalArticlesCell", for: indexPath)
            return cell
        }
    }

    func updateArticles() {
        ref = Database.database().reference().child("Articles")
        ref.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0 {
                self.articlesList.removeAll()

                for articles in snapshot.children.allObjects as! [DataSnapshot] {
                    let articleObject = articles.value as? [String: AnyObject]
                    let articleSrc = articleObject?["src"]
                    let articleTime = articleObject?["time"]
                    let articleImg = articleObject?["img"]
                    let articleTitle = articleObject?["title"]
                    let articleId = articleObject?["id"]

                    let article = Articles(src: articleSrc as? String, time: articleTime as? String, img: articleImg as? String, title: articleTitle as? String, id: articleId as? Int)
                    self.articlesList.append(article)
                }
                
                // 기사 전체보기 추가
                self.articlesList.append(Articles(src: "https://hypebeast.kr/footwear", time: nil, img: nil, title: nil, id: nil))
                self.tableView.reloadData()
            }
        })
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let articleURL = self.articlesList[indexPath.row].src ?? ""
        viewOnSafari(url: articleURL)
    }
}
