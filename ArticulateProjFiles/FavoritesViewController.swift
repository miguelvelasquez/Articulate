//
//  FavoritesViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/3/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noSavedLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var savedArticles: [FarticleMO] = []
    var articles: [Article]? = []
    var cells: [ArticleCell]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchArticlesFromCoreData()
        loadImages()
        noSavedLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articles = []
        fetchArticlesFromCoreData()
        self.collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "farticleCell", for: indexPath) as! ArticleCell
        let farticle = self.savedArticles[indexPath.item]
        let article = Article(title: farticle.title!, url: farticle.url!, imageUrl: farticle.imageUrl!, favorite: true)
        cell.title.text = ""
        cell.article = nil
        cell.article = article
        article.saved = 1
        article.favorite = true
        articles?.append(article)
        cell.title.text = self.articles?[indexPath.item].title
        cell.setYellowStar()
        //cell.author.image = self.articles?[indexPath.item].authorImg
        cell.image.image = cell.article?.image
        cell.layer.cornerRadius = 10
        cells?.append(cell)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        webVC.url = self.articles?[indexPath.item].url
        webVC.article = self.articles?[indexPath.item]
        self.present(webVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if savedArticles.count == 0 {
            noSavedLabel.isHidden = false
        } else {
            noSavedLabel.isHidden = true
        }
        return savedArticles.count
    }
    
    func updateFaves() {
        for cell in cells! {
            cell.updateStar()
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func deleteAllArticlesFromCoreData() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<FarticleMO> = FarticleMO.fetchRequest()
        do {
            //go get the results
            let articles = try getContext().fetch(fetchRequest)
            
            //You need to convert to NSManagedObject to use 'for' loops
            for article in articles as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                context.delete(article)
            }
            //save the context

            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func fetchArticlesFromCoreData() {
        do {
            savedArticles = try context.fetch(FarticleMO.fetchRequest())
        } catch {
            print("Fetching Articles from Core Data failed :( ")
        }
    }
    
    func loadImages() {
        if articles != nil {
            for article in articles! {
                article.loadImage(from: article.imageUrl!)
            }
        }
    }


}
