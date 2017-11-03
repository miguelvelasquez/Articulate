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
    var cells: [ArticleCell]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        cells = []
        fetchArticles()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkArticlesFromCoreData()
        //updateFaves()
    }
    
    //Fetch Articles from newsapi.org
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
                        if let title = articleFromJson["title"] as? String, let url =
                            articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            let art = Article(title: title, url: url, imageUrl: urlToImage, favorite: false)
                            art.loadImage(from: art.imageUrl!)
                            self.articles?.append(art)
                        }
                        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = ""
        cell.article = nil
        cell.setEmptyStar()
        cell.article = self.articles?[indexPath.item]
        cell.title.text = cell.article?.title
        //cell.author.image = self.articles?[indexPath.item].authorImg
        cell.image.image = cell.article?.image
        cell.layer.cornerRadius = 10
        cells?.append(cell)
        if cell.article?.getFavStatus() == true {
            cell.setYellowStar()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        webVC.url = self.articles?[indexPath.item].url
        webVC.article = self.articles?[indexPath.item]
        self.present(webVC, animated: true, completion: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    
    func updateFaves() {
        for cell in cells! {
            cell.updateStar()
        }
    }
    
    func checkArticlesFromCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var savedArticles: [FarticleMO] = []
        do {
            savedArticles = try context.fetch(FarticleMO.fetchRequest())
        } catch {
            print("Fetching Articles from Core Data failed :( ")
        }
        for cell in cells! {
            for farticle in savedArticles {
                if cell.article?.url == farticle.url {
                    cell.article?.saved = 1
                    cell.article?.favorite = true
                    cell.setYellowStar()
                } else {
                    cell.article?.saved = 0
                    cell.article?.favorite = false
                    cell.setEmptyStar()
                }
            }
        }
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








