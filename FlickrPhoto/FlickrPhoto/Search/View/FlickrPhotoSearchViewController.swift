//
//  ViewController.swift
//  FlickrPhoto
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import UIKit

class FlickrPhotoSearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    var viewModel: FlickrPhotoListingViewModel?
    var loaderViewController: SWLoaderViewController!
    struct Constants {
        static let enterTextMsg = "Enter some text to search"
        static let errorPopupHeading = "Error"
        static let ok = "OK"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FlickrPhotoListingViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.delegate = self
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if let searchText = searchTextField.text {
            if searchText.isEmpty {
                showErrorPopup(errorMsg: Constants.enterTextMsg)
            } else {
                viewModel?.fetchPhotos(itemName: searchText)
            }
        }
    }

    func navigateToListing() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "flickrphotolistingviewcontroller") as? FlickrPhotoListingViewController{
            vc.viewModel = viewModel
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    private func showErrorPopup(errorMsg: String) {
        let alert = UIAlertController(title: Constants.errorPopupHeading, message:  errorMsg, preferredStyle: UIAlertController.Style.actionSheet)
        let actionX = UIAlertAction(title:  Constants.ok, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(actionX)
        present(alert, animated: true, completion: nil)
    }
}
extension FlickrPhotoSearchViewController: FlickrPhotoListingViewModelDelegate {
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
            debugPrint("Navigate to listing")
            loaderViewController.remove()
            self.navigateToListing()
        case .error(let errorString):
            debugPrint(errorString)
            loaderViewController.remove()
            showErrorPopup(errorMsg: errorString)
        }
    }
}

