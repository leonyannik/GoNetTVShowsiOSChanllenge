//
//  DetailViewController.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData
import SafariServices
import NotificationBannerSwift

class DetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveDelete: UIBarButtonItem!
    @IBOutlet weak var webPageButton: UIButton!
    @IBOutlet weak var imdbButton: UIButton!
    // MARK: - Constants
    
    // MARK: - Variables
    var TvShow: ShowSt?
    var imagePlaceHolder = UIImage()
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
        customizeView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        customizeView()
    }
    // MARK: - Outlet functions
    @IBAction func toggleFavorite(_ sender: Any) {
        if TvShow!.isFavorite {
            let request: NSFetchRequest<Show> = Show.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", entity.property.id, TvShow!.id)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
                try moc.save()
            }catch {
                print(error, "This is the error trying to delete the thing from coreData")
            }
            if let index = favoriteShows.index(where: { $0.id == TvShow!.id }) {
                favoriteShows.remove(at: index)
            }
        }else {
            guard let thisShow = NSEntityDescription.insertNewObject(forEntityName: entity.show, into: moc) as? Show else {return}
            thisShow.id = TvShow!.id
            let image = imageView.image!
            thisShow.thumb = image.pngData()! as NSData
            thisShow.thumbURL = TvShow!.thumbURL
            thisShow.imageURL = TvShow!.imageURL
            thisShow.summary = TvShow!.summary
            thisShow.site = TvShow!.site
            thisShow.language = TvShow!.language
            thisShow.name = TvShow!.name
            thisShow.imdb = TvShow!.IMDb
            do {
                try moc.save()
            }
            catch {
                print("Erro on saving: \(error)")
            }
            favoriteShows.append(thisShow)
        }
        DispatchQueue.main.async {
            self.TvShow!.isFavorite = !self.TvShow!.isFavorite
            self.saveDelete.title = self.TvShow!.isFavorite ? "Remove" : "MakeFavorite"
            if self.TvShow!.isFavorite {
            let banner = GrowingNotificationBanner(title: "Yei", subtitle: "You liked this tv show and is added to your favorites page", style: .success)
            banner.show()
            }else {
                let banner = GrowingNotificationBanner(title: "Well", subtitle: "No more favorite", style: .danger)
                banner.show()
            }
        }
    }
    @IBAction func webPageButtonTapped(_ sender: Any) {
        let safari = SFSafariViewController(url: URL(string: TvShow!.site)!)
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
    }
    @IBAction func imdbButtonTapped(_ sender: Any) {
        let safari = SFSafariViewController(url: URL(string: "https://www.imdb.com/title/\(TvShow!.IMDb)")!)
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
    }
    // MARK: - Functions
    func customizeView() {
        title = TvShow!.name
        saveDelete.title = TvShow!.isFavorite ? "Remove" : "MakeFavorite"
        imdbButton.isHidden = TvShow!.IMDb == ""
        imdbButton.backgroundColor = UIColor(red: 0, green: 0.813, blue: 0.692, alpha: 1)
        imdbButton.layer.cornerRadius = 8
        webPageButton.backgroundColor = UIColor(red: 0, green: 0.813, blue: 0.692, alpha: 1)
        webPageButton.layer.cornerRadius = 8
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0.813, blue: 0.692, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.813, blue: 0.692, alpha: 1)
    }
    
    func populateView() {
        activityIndicator.startAnimating()
        imageView.image = imagePlaceHolder
        summaryLabel.text = TvShow!.summary
        imageFromServerURL(urlString: TvShow!.imageURL)
    }
    
    func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                self.waitingView.isHidden = true
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.imageView.image = image
                    self.waitingView.isHidden = true
                }
            }
        }).resume()
    }

}

extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
