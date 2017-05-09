//
//  ArticleViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/2/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        fetchArticles()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=google-news&sortBy=top&apiKey=24c5003b245044d79c664b8182d5fc46")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error ?? "An error occurred")
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let url =
                            articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            article.title = title
                            article.url = url
                            article.imageUrl = urlToImage
                            article.setAuthorPic()
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        print("selected")
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].title
        //cell.author.image = self.articles?[indexPath.item].authorImg
        if (self.articles?[indexPath.item].imageUrl != nil) {
            cell.image.loadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        }
        cell.layer.cornerRadius = 10
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
}

extension UIImageView {
    
    func loadImage(from url: String) {
        let url = URL(string: url)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let img = UIImage.init(data: data!)
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        })
        task.resume()
    }
}








