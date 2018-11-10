//
//  FavoritesViewController.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/3/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Constants
    // MARK: - Variables
    var TvShows = [ShowSt]()
    var indexToPass = 0
    var imageToPass = UIImage()
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        customizeView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        customizeView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromFavorites" {
            let controller = segue.destination as! DetailViewController
            let tvShow = favoriteShows[indexToPass]
            controller.TvShow = ShowSt(id: tvShow.id!, name: tvShow.name!, summary: tvShow.summary!, imageURL: tvShow.imageURL!, thumbURL: tvShow.thumbURL!, IMDb: tvShow.imdb!, language: tvShow.language!, site: tvShow.site!)
            controller.TvShow?.isFavorite = true
            controller.imagePlaceHolder = imageToPass
        }
    }
    // MARK: - Outlet functions
    // MARK: - Functions
    func setView() {
        title = "Favorite TV Shows"
        tableView.tableFooterView = UIView()
    }
    
    func customizeView() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = favoriteShows[row]
        let index = String(row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell") as! ShowTableViewCell
        cell.index = index
        cell.titleLabel.text = item.name
        cell.showImageView.image = #imageLiteral(resourceName: "placeholder")
        cell.showImageView.image = UIImage(data: item.thumb as! Data)
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexToPass = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! ShowTableViewCell
        imageToPass = cell.showImageView.image!
        performSegue(withIdentifier: "toDetailFromFavorites", sender: nil)
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
        let item = favoriteShows[row]
        let action = UITableViewRowAction(style: .destructive, title: "Delete") {action, index  in
            let request: NSFetchRequest<Show> = Show.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", entity.property.id, item.id!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
                try moc.save()
            }catch {
                print(error, "This is the error trying to delete the thing from coreData")
            }
            DispatchQueue.main.async {
                favoriteShows.remove(at: row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        action.backgroundColor = UIColor.red
        return [action]
    }
}

