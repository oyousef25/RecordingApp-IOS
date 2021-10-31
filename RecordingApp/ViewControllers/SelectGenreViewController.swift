//
//  SelectGenreViewController.swift
//  RecordingApp
//
//  Created by Omar Yousef on 2021-10-31.
//

import UIKit

class SelectGenreViewController: UITableViewController {
    //MARK: Properties
    //An array of genres to ask the user which genre does the audio belong to
    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //Adding a title to the viewController
        title = "Select genre"
        //Adding a bar button item
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
        //Registering our tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    //Deciding how many sections the tableview will have
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Deciding how many rows the tableview will have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreViewController.genres.count
    }

    //Adding the appropiriate values to each cell in the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = SelectGenreViewController.genres[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    //When a cell is pressed, we are going to pass the selected genre
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let genre = cell.textLabel?.text ?? SelectGenreViewController.genres[0]
            let vc = AddCommentsViewController()
            vc.genre = genre
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
