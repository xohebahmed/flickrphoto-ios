//
//  FlickrPhotoListingViewController.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

class FlickrPhotoListingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "flickrphotocell"
    let margin: CGFloat = 10
    let cellsPerRow = 3
    var viewModel: FlickrPhotoListingViewModel!
    var loaderViewController: SWLoaderViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
    }
    private func setUpFlowLayoutForCollectionView() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
}

extension FlickrPhotoListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for:
            indexPath) as? FlickrPhotoCollectionViewCell {
            cell.tag = indexPath.row
            self.viewModel.fetchImageForPhoto(atIndexPath: indexPath, completion: { (data, error) in
                DispatchQueue.main.async {
                    if let `data` = data,
                    let image = UIImage(data: data) {
                        if cell.tag == indexPath.row {
                            cell.imageView.image = image
                        }
                    }
                }
            })
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let count = viewModel.photos?.count, count == indexPath.row + 1 ,
            viewModel.isMoreItemsAvailableToBeFetched() {
            viewModel.fetchMorePhotos()
        }
    }
}
extension FlickrPhotoListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow  - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        let size = CGSize(width: itemWidth, height: itemWidth)
        return size
    }
}
extension FlickrPhotoListingViewController: FlickrPhotoListingViewModelDelegate {
    func updateListingViewState() {
        guard let viewState = viewModel?.viewState
            else {
                return
        }
        switch viewState {
        case .loading:
            debugPrint("Photos are loading")
            loaderViewController = SWLoaderViewController()
            add(loaderViewController)
        case .photosAvailable:
             loaderViewController.remove()
            self.collectionView.reloadData()
        case .error(let errorString):
             loaderViewController.remove()
            debugPrint(errorString)
            //showErrorPopup(errorMsg: errorString)
        }
    }
}
