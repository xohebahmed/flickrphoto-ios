//
//  FlickrPhotoCollectionViewCell.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import UIKit

class FlickrPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
