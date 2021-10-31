//
//  AddCommentsViewController.swift
//  RecordingApp
//
//  Created by Omar Yousef on 2021-10-31.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate{
    /*
     MARK: Properties
     */
    var genre: String!

    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identify your tune, enter them here."

    //MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changing the title and adding a bar button item
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
        
        //Setting a placeholder for the comments texView
        comments.text = placeholder
    }
    
    override func loadView() {
        //Creating a new View and changing the bg
        view = UIView()
        view.backgroundColor = .white

        //Creating a new textview to allow the user to type comments
        comments = UITextView()
        
        //textview styles
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(comments)
        
        //textview constraints
        comments.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comments.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: Actions
    //When the submit button is tapped we are going to pass our genre property to SubmitViewController()
    @objc func submitTapped() {
//        let vc = SubmitViewController()
//        vc.genre = genre
//
//        if comments.text == placeholder {
//            vc.comments = ""
//        } else {
//            vc.comments = comments.text
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Methods
    //Textview method
    func textViewDidBeginEditing(_ textView: UITextView) {
        //removing the text view placeholder when the user starts typing
        if textView.text == placeholder {
            textView.text = ""
        }
    }
}
