//
//  ShowsViewController.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/3/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

var imagesCacheContent = [String: UIImage]()
var favoriteShows = [Show]()
class ShowsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Constants
    let refreshControl = UIRefreshControl()
    // MARK: - Variables
    var TvShows = [ShowSt]()
    var indexToPass = 0
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCacheContent = [:]
        setView()
        customizeView()
        readFromPersistence()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        customizeView()
    }
    override func viewDidAppear(_ animated: Bool) {
        for (index,show) in TvShows.enumerated() {
            TvShows[index].isFavorite = false
            if favoriteShows.contains(where: {$0.id == show.id } ) {
                TvShows[index].isFavorite = true
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        imagesCacheContent = [:]
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromMainList" {
            let controller = segue.destination as! DetailViewController
            controller.TvShow = TvShows[indexToPass]
            controller.imagePlaceHolder = imagesCacheContent[String(indexToPass)] ?? UIImage()
        }
    }
    // MARK: - Outlet functions
    // MARK: - Functions
    func setView() {
        title = "TV Shows"
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action:  #selector(self.pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
    }
    
    func customizeView() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.122, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func pullToRefresh() {
        if refreshControl.isRefreshing {
            imagesCacheContent = [:]
            populateItems()
        }
    }
    
    func populateItems() {
        let request = Request.fromURL(mainAddress: mainURL, call: showsCall)
        API.fetcher.getShows(with: request, success: { (showsReturned) in
            self.TvShows = showsReturned
            self.doneLoadingShows()
        }) { (error) in
            print(error)
            self.doneLoadingShows()
            let alert = UIAlertController(title: "Oops, something went wrong", message: "An error occurred while fetching data. Do you want to try again?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.populateItems()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func doneLoadingShows() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func readFromPersistence() {
        let showsRequest: NSFetchRequest<Show> = Show.fetchRequest()
        moc.perform {
            do {
                let fetchedShows = try showsRequest.execute()
                favoriteShows = fetchedShows
            } catch {
                print("Error on read persistence: \(error)")
            }
            DispatchQueue.main.async {
                self.populateItems()
            }
        }
    }
}

extension ShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = TvShows[row]
        let index = String(row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell") as! ShowTableViewCell
        cell.index = index
        cell.titleLabel.text = item.name
        cell.showImageView.image = #imageLiteral(resourceName: "placeholder")
        imagesCacheContent[String(row)] != nil ? cell.showImageView.image = imagesCacheContent[index] : cell.imageFromServerURL(urlString: item.thumbURL, index: index)
        return cell
    }
}

extension ShowsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        indexToPass = indexPath.row
        performSegue(withIdentifier: "toDetailFromMainList", sender: nil)
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
        var item = TvShows[row]
        let cell = tableView.cellForRow(at: indexPath) as! ShowTableViewCell
        if item.isFavorite {
            let action = UITableViewRowAction(style: .destructive, title: "Delete") {action, index  in
                let request: NSFetchRequest<Show> = Show.fetchRequest()
                request.predicate = NSPredicate(format: "%K == %@", entity.property.id, item.id)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
                do {
                    try moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
                    try moc.save()
                }catch {
                    print(error, "This is the error trying to delete the thing from coreData")
                }
                
                self.TvShows[row].isFavorite = false
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    if let index = favoriteShows.index(where: { $0.id == item.id }) {
                        favoriteShows.remove(at: index)
                    }
                }
            }
            action.backgroundColor = UIColor.red
            return [action]
        }else {
            let action = UITableViewRowAction(style: .default, title: "Favorite") {action, index  in
                guard let thisShow = NSEntityDescription.insertNewObject(forEntityName: entity.show, into: moc) as? Show else {return}
                thisShow.id = item.id
                let image = cell.showImageView.image!
                thisShow.thumb = image.pngData()! as NSData
                thisShow.thumbURL = item.thumbURL
                thisShow.imageURL = item.imageURL
                thisShow.summary = item.summary
                thisShow.site = item.site
                thisShow.language = item.language
                thisShow.name = item.name
                thisShow.imdb = item.IMDb
                do {
                    try moc.save()
                }
                catch {
                    print("Erro on saving: \(error)")
                }
                self.TvShows[row].isFavorite = true
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    favoriteShows.append(thisShow)
                }
            }
            action.backgroundColor = UIColor.green
            return [action]
        }
    }
}
