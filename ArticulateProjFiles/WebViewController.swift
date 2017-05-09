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
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
