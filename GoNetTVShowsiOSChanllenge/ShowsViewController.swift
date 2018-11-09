//
//  ShowsViewController.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/3/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Constants
    // MARK: - Variables
    var TvShows = [String]()
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TvShows = ["Vikings", "The Last Kingdom", "Firends", "SuperGirl", "Titans"]
        tableView.reloadData()
        customizeView()
        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    // MARK: - Outlet functions
    // MARK: - Functions
    func customizeView() {
        title = "TV Shows"
         navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

}

extension ShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = TvShows[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell") as! ShowTableViewCell
        cell.titleLabel.text = item
        return cell
    }
}

extension ShowsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = indexPath.row
        let favoriteAction = UITableViewRowAction(style: .default, title: "Favorite") {action, index  in
            print("This will be a favorite")
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {action, index  in
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        TvShows.remove(at: row)
        deleteAction.backgroundColor = UIColor.red
        return [favoriteAction, deleteAction]
    }
}
