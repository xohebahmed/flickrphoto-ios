//
//  Photos.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import Foundation

struct Photos {
    let page: Int?
    let numberOfPages: Int?
    let photosPerPage: Int?
    let totalNumberOfPhotos: String?
    var photoArray: [Photo]?
    init(photosParams: [String: Any?]) {
        let photosDict = photosParams["photos"] as?  [String: Any?]
        self.page = photosDict?["page"] as? Int
        self.numberOfPages = photosDict?["pages"] as? Int
        self.photosPerPage = photosDict?["perpage"] as? Int
        self.totalNumberOfPhotos = photosDict?["total"] as? String
        if let photoDictArray = photosDict?["photo"] as? [[String: Any?]] {
            self.photoArray = []
            for photoDict in photoDictArray {
                let photo = Photo(photosParams: photoDict)
                self.photoArray!.append(photo)
            }
        }
    }
}
