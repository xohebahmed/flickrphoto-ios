//
//  Photo.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import Foundation

struct Photo {
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let isPublic: Int?
    let isFriend: Int?
    let isFamily: Int?
    init(photosParams: [String: Any?]) {
        id       = photosParams["id"] as? String
        owner    = photosParams["owner"] as? String
        secret   = photosParams["secret"] as? String
        title    = photosParams["title"] as? String
        server   = photosParams["server"] as? String
        farm     = photosParams["farm"] as? Int
        isPublic = photosParams["ispublic"] as? Int
        isFriend = photosParams["isfriend"] as? Int
        isFamily = photosParams["isfamily"] as? Int
    }
}
