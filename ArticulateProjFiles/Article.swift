//
//  Article.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/2/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit
import CoreData


class Article: NSObject {
    var title: String?
    var author: String?
    var url: String?
    var imageUrl: String?
    var image: UIImage?
    var authorImg: UIImage?
    var favorite: Bool
    var saved = 0

    
    init(title: String, url: String, imageUrl: String, favorite: Bool) {
        self.title = title
        self.url = url
        self.imageUrl = imageUrl
        self.favorite = favorite
    }
    
    func setAuthorPic() {
        
    }
    
    func favToggle() {
        if favorite == false {
            favorite = true
        } else {
            favorite = false
        }
    }
    
    func getFavStatus() -> Bool {
        return favorite
    }
    
    func saveArticle() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let farticle = FarticleMO(context: context)
        farticle.author = author
        farticle.favorite = true
        farticle.url = url
        farticle.imageUrl = imageUrl
        farticle.title = title
        
        appDelegate.saveContext()
        saved = 1
        
    }
    
    func unsaveArticle() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<FarticleMO> = FarticleMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url==%@", self.url!)
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
        saved = 0
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
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
