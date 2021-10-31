//
//  ViewController.swift
//  RecordingApp
//
//  Created by Omar Yousef on 2021-10-31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the viewController's title
        title = "What's that Whistle?"
        
        //Adding a nbar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        
        //Adding another bar button item
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }
    
    /*
        MARK: Methods
     */
    @objc func addWhistle() {
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

