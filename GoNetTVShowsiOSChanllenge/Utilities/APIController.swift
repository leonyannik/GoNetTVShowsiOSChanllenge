//
//  APIController.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation
import UIKit

let mainURL = "http://api.tvmaze.com/"
let showsCall = "shows"

class API {
    static let fetcher = API()
    let defaultSessionConfiguration = URLSessionConfiguration.default
    func getShows(with request: URLRequest, success: @escaping ([ShowSt]) -> Swift.Void, fail: @escaping (String) -> Swift.Void) {
        makeTheCall(request: request, delegate: nil, success: { (datos) in
            let shows = self.createShows(shows: datos)
            success(shows)
        }, passSession: nil) { (thisError) in
            print(thisError)
            fail(thisError)
        }
    }
    
    func createShows(shows: Array<Dictionary<String, Any>>) -> [ShowSt]{
        var showsHere = [ShowSt]()
        for show in shows {
            guard let id = show["id"] as? Int else { continue }
            let name = show["name"] as? String ?? ""
            let HTMLsummary = show["summary"] as? String ?? ""
            let imageURL = (show["image"] as? Dictionary<String, String> ?? ["original":""])["original"]  ?? ""
            let thumbURL = (show["image"] as? Dictionary<String, String> ?? ["medium":""])["medium"] ?? ""
            let IMDb = (show["externals"] as? Dictionary<String, Any> ?? ["imdb":""])["imdb"] as? String ?? ""
            let language = show["language"] as? String ?? ""
            let site = show["officialSite"] as? String ?? ""
            let summary = HTMLsummary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            var thisShow = ShowSt(id: String(id), name: name, summary: summary, imageURL: imageURL, thumbURL: thumbURL, IMDb: IMDb, language: language, site: site)
            if (favoriteShows.filter { $0.id == String(id) }).count > 0 {
                thisShow.isFavorite = true
            }
            showsHere.append(thisShow)
        }
        return showsHere
    }
    
    func makeTheCall(request: URLRequest, delegate: URLSessionDelegate?, success: @escaping (Array<Dictionary<String, Any>>) -> Swift.Void, passSession: ((URLSession) -> Swift.Void)?, fail: @escaping (String) -> Swift.Void) {
        let session = URLSession(configuration: defaultSessionConfiguration, delegate: delegate, delegateQueue: OperationQueue.main)
        if passSession != nil {
            passSession!(session)
        }
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if data != nil {
                do {
                    guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {
                        guard let realResponse = response as? HTTPURLResponse else { print("Not a response in \(String(describing: request.url))"); fail("Not a response in \(String(describing: request.url))"); return}
                        guard let data = try JSONSerialization.jsonObject(with: data!,options: .mutableContainers) as? Dictionary<String, Any> else { print("Not a response in \(String(describing: request.url))"); return}
                        if realResponse.statusCode != 400 {
                            fail("Error code: " + String(realResponse.statusCode))
                            return
                        }
                        guard let error = data["error"] as? Dictionary<String, Any> else { print("Not a response in \(String(describing: request.url))"); fail("Error code: " + String(realResponse.statusCode)); return}
                        guard let errorDescription = error["description"] as? String else { print("Not a response in \(String(describing: request.url))"); fail("Error code: " + String(realResponse.statusCode)); return}
                        print(errorDescription)
                        fail(errorDescription)
                        return
                    }
                    guard let datos = try JSONSerialization.jsonObject(with: data!,options: .mutableContainers) as? Array<Dictionary<String, Any>> else { print("Data from login was not dictionary");return }
                    success(datos)
                } catch {
                    print(error)
                    fail(error.localizedDescription)
                    return
                }
            }else{
                let thisError = "session validation fail"
                print(thisError)
                fail(thisError)
            }
        }).resume()
    }
}
