//
//  WebViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/3/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var star: UIButton!
    
    var url: String?
    var article: Article?
    
    let emptyStar = #imageLiteral(resourceName: "w-bord star.png")
    let yellowStar = #imageLiteral(resourceName: "yellow star.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        updateStar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func favWasPressed(_ sender: Any) {
        article?.favToggle()
        if article?.getFavStatus() == true {
            setYellowStar()
            article?.saveArticle()
            article?.saved = 1
            article?.favorite = true
        } else {
            setEmptyStar()
            article?.unsaveArticle()
            article?.saved = 0
            article?.favorite = false
        }
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
        } else {
            setEmptyStar()
        }
    }

    @IBAction func backWasPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
