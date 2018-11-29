//
//  APICommunicator.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import Foundation

protocol APICommunicatorProtocol {
    func searchForItem(itemName name: String,
                       pageNo: Int,
                       completionHandler: @escaping (Dictionary<String, AnyObject>?,
        String?) -> Void)
    func downloadImage(url: String,
                       completionHandler: @escaping (Data?, Error?) -> Void)
}

class APICommunicator: APICommunicatorProtocol {
    let baseUrl          = "https://api.flickr.com/services/rest/?"
    let itemSearchPath   = "method=flickr.photos.search"
    let apiKey           = "f2ddfcba0e5f88c2568d96dcccd09602"
    let imageCache = NSCache<NSString, NSData>()
    
    func searchForItem(itemName name: String,
                       pageNo: Int,
                       completionHandler: @escaping (Dictionary<String, AnyObject>?,
                                                     String?) -> Void) {
        // Adding percent encoding
        guard let escapeName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {
            completionHandler(nil, nil)
            return
        }
        let searchUrl = baseUrl + itemSearchPath + "&api_key=" + apiKey + "&format=json&nojsoncallback=1&safe_search=1" + "&page=\(pageNo)" + "&text=\(escapeName)"
        let myUrl = URL(string: searchUrl)
        debugPrint("URL for search is \(searchUrl)")
        let task = URLSession.shared.dataTask(with: myUrl!) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(nil, nil)
                return
            }
            if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                completionHandler(responseDict, nil)
            } else {
                completionHandler(nil, error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    func downloadImage(url: String,
                              completionHandler: @escaping (Data?, Error?) -> Void) {
        let myUrl = URL(string: url)
        if let cachedImageData = imageCache.object(forKey: url as NSString) {
            completionHandler(Data(referencing: cachedImageData), nil)
        } else {
            URLSession.shared.dataTask(with: myUrl!) {
                (data, response, error) in
                guard let `data` = data else {
                    if let `error` = error {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(nil, nil)
                    }
                    return
                }
                self.imageCache.setObject(data as NSData, forKey: url as NSString)
                completionHandler(data, nil)
                }.resume()
        }
    }
}

