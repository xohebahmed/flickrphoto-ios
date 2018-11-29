//
//  FlickrPhotoListingViewModel.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import Foundation

struct Constants {
    static let defaultErrorMsg = "Oops! Something went wrong"
    static let urlPlaceHolderString = "https://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg"
}
protocol FlickrPhotoListingViewModelDelegate {
    func updateListingViewState()
}
enum FlickrPhotoListingViewState {
    case loading
    case photosAvailable
    case error(String)
}
class FlickrPhotoListingViewModel {
    var pageNo = 1
    var delegate: FlickrPhotoListingViewModelDelegate?
    var photos: [Photo]?
    var numberOfSections: Int = 1
    var itemName: String?
    var totalItems: Int?
    var viewState: FlickrPhotoListingViewState? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateListingViewState()
            }
        }
    }
    var apiCommunicator: APICommunicatorProtocol
    
    init(apiCommunicator: APICommunicatorProtocol = APICommunicator()) {
        self.apiCommunicator = apiCommunicator
    }
    
    func fetchPhotos(itemName: String) {
        viewState = .loading
        apiCommunicator.searchForItem(itemName: itemName, pageNo: pageNo) { [weak self] (response, error) in
            debugPrint("Response is \(String(describing: response))")
                guard let `self` = self else { return }
                guard let photosDict = response else {
                    let errorString = error ?? Constants.defaultErrorMsg
                    self.viewState = .error(errorString)
                    return
                }
                let photos = Photos(photosParams: photosDict)
                debugPrint("****Page No. is \(photos.page!)")
                debugPrint("****Total Items in this page are \(photos.photoArray!.count)")
                
                let photoList = photos.photoArray
                if self.photos == nil {
                    self.photos = [Photo]()
                }
                guard let newPhotoList = photoList else {
                    self.viewState = .error(Constants.defaultErrorMsg)
                    return
                }
                if let totalNumberOfPhotos = photos.totalNumberOfPhotos {
                    self.totalItems = Int(totalNumberOfPhotos)
                }
                self.itemName = itemName
                self.photos = self.photos! + newPhotoList
                debugPrint("****Totals Photos available now are \(self.photos!.count)")
                self.viewState = .photosAvailable
        }
    }
    func fetchMorePhotos() {
        pageNo += 1
        if let item = self.itemName {
            self.fetchPhotos(itemName: item)
        }
    }
    func fetchImageForPhoto(atIndexPath indexPath: IndexPath,
                            completion: @escaping (Data?, String?) -> Void ) {
        let photo = photos?[safe: indexPath.row]
        guard let urlString = getUrl(forPhoto: photo)  else {
            completion(nil, Constants.defaultErrorMsg)
            return
        }
        apiCommunicator.downloadImage(url: urlString) { (data, error) in
            guard let `data` = data
            else {
                if let `error` = error {
                    completion(nil, error.localizedDescription)
                } else {
                    completion(nil, nil)
                }
                return
            }
            completion(data, nil)
        }
    }
    func getPhoto(atIndexPath indexPath: IndexPath) -> Photo? {
        return photos?[safe: indexPath.row]
    }
    private func getUrl(forPhoto photo: Photo?) -> String? {
        guard let `photo` = photo,
            let farm  = photo.farm,
            let server = photo.server,
            let id = photo.id,
            let secret = photo.secret
            else {
                return nil
        }
        var url = Constants.urlPlaceHolderString
        url = url.replacingOccurrences(of: "{farm}", with: "\(farm)")
            .replacingOccurrences(of: "{server}", with: server)
            .replacingOccurrences(of: "{id}", with: id)
            .replacingOccurrences(of: "{secret}", with: secret)
        return url
    }
    func isMoreItemsAvailableToBeFetched() -> Bool {
        if let count = photos?.count,
            let totalPhotos = self.totalItems,
            count >= totalPhotos {
            return false
        }
        return true
    }
}
