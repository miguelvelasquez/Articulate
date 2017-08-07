//
//  ArticleCell.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/2/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit
import CoreData

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var author: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var star: UIButton!
    
    var article: Article?
    
    let emptyStar = #imageLiteral(resourceName: "empty star.png")
    let yellowStar = #imageLiteral(resourceName: "yellow star.png")
    
    var fave = 0
    
   @IBAction func fav(_ sender: Any) {
        article?.favToggle()
        updateStar()
    }
    
    func setYellowStar() {
        star.setImage(yellowStar, for:UIControlState.normal)
    }
    
    func setEmptyStar() {
        star.setImage(emptyStar, for:UIControlState.normal)
    }
    
    func updateStar() {
        if (article?.getFavStatus() == true) {
            setYellowStar()
            if (article?.saved == 0) {
                saveArticle()
                article?.saved = 1
            }
        } else {
            setEmptyStar()
            if (article?.saved == 1) {
                unsaveArticle()
                article?.saved = 0
            }
        }
    }
    
    func saveArticle() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let farticle = FarticleMO(context: context)
        farticle.author = article?.author
        farticle.favorite = true
        farticle.url = article?.url
        farticle.imageUrl = article?.imageUrl
        farticle.title = article?.title

        appDelegate.saveContext()
        print("save article")

    }
    
    func unsaveArticle() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<FarticleMO> = FarticleMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url==%@", (article?.url)!)
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch {
            print("There was an error saving context")
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}


