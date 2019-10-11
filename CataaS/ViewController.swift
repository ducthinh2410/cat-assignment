//
//  ViewController.swift
//  CataaS
//
//  Created by Thinh Vo on 10.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    let catLoader = APIRequestLoader<CatRequest>(request: CatRequest())

    lazy private(set) var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your cat"
        return searchController
    }()

    private var timer: Timer?
    private var lastSearchedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cat"
        definesPresentationContext = true

        navigationItem.searchController = searchController

        // Load an initial random image
        fetchCat(nil)
    }

    @objc func fetchCat(_ tag: String? = nil) {
        loadingIndicator.startAnimating()

        catLoader.loadRequest(requestData: tag) { [weak self] (image, error) in
            guard let strongSelf = self else {
                return
            }

            DispatchQueue.main.async {
                strongSelf.loadingIndicator.stopAnimating()

                if let err = error {
                    strongSelf.imageView.image = UIImage(named: "placeholder")
                    print(err.localizedDescription)
                } else {
                    strongSelf.imageView.image = image
                }
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()

        if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            searchText != "",
            searchText != self.lastSearchedText {

            self.lastSearchedText = searchText
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (_) in
                self.fetchCat(searchText)
            })
        }
    }
}
